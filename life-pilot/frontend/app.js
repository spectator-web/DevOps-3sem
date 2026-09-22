const API = "http://localhost:5075/api/products";

async function loadProducts() {
    const response = await fetch(API);
    const products = await response.json();

    const tbody = document.getElementById("list");
    tbody.innerHTML = "";

    if (products.length === 0) {
        const tr = document.createElement("tr");
        tr.innerHTML = `<td colspan="4" class="empty">Пока пусто</td>`;
        tbody.appendChild(tr);
        return;
    }

    for (const p of products) {
        const tr = document.createElement("tr");
        tr.innerHTML = `
            <td>${p.id}</td>
            <td>${p.name}</td>
            <td>${p.description ?? ""}</td>
            <td>${p.unit}</td>
        `;
        tbody.appendChild(tr);
    }
}

async function saveProduct(event) {
    event.preventDefault();

    const form = event.target;
    const data = {
        name: form.name.value.trim(),
        description: form.description.value.trim(),
        unit: form.unit.value.trim()
    };

    const response = await fetch(API, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
    });

    if (!response.ok) {
        alert("Ошибка сохранения: " + response.status);
        return;
    }

    form.reset();
    await loadProducts();
}

loadProducts();