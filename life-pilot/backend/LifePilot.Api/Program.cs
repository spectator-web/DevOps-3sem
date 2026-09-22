using Npgsql;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

var connString = builder.Configuration.GetConnectionString("Default")
    ?? throw new InvalidOperationException("Connection string 'Default' is not configured.");

builder.Services.AddNpgsqlDataSource(connString);

var app = builder.Build();

app.UseCors();

app.MapGet("/api/products", async (NpgsqlDataSource dataSource) =>
{
    var products = new List<ProductDto>();

    await using var command = dataSource.CreateCommand(
        "SELECT id, name, description, unit FROM products ORDER BY id");

    await using var reader = await command.ExecuteReaderAsync();

    while (await reader.ReadAsync())
    {
        products.Add(new ProductDto(
            reader.GetInt32(0),
            reader.GetString(1),
            reader.IsDBNull(2) ? null : reader.GetString(2),
            reader.GetString(3)
        ));
    }

    return Results.Ok(products);
});

app.MapPost("/api/products", async (NpgsqlDataSource dataSource, CreateProductDto input) =>
{
    await using var command = dataSource.CreateCommand(
        "INSERT INTO products(name, description, unit) VALUES (@name, @description, @unit) RETURNING id");

    command.Parameters.AddWithValue("name", input.Name);
    command.Parameters.AddWithValue("description", (object?)input.Description ?? DBNull.Value);
    command.Parameters.AddWithValue("unit", input.Unit);

    var id = (int)(await command.ExecuteScalarAsync())!;

    return Results.Created($"/api/products/{id}", new { Id = id });
});

app.Run();

record ProductDto(int Id, string Name, string? Description, string Unit);
record CreateProductDto(string Name, string? Description, string Unit);