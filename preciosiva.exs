defmodule Preciosiva do
  defmodule Producto do
    defstruct [:nombre, :stock, :precio_sin_iva, :iva]
  end

  def calcular_precio_final(%Producto{nombre: nombre, precio_sin_iva: precio, iva: iva}) do
    precio_final = precio * (1 + iva)
    {nombre, precio_final}
  end

  #secuencial uno por uno
  def precios_secuencial (productos) do
    Enum.map(productos, &calcular_precio_final/1)
  end

  #concurrente proceso por producto
  def precios_concurrencia (productos) do
    Enum.map(productos, fn producto ->
      Task.async(fn -> calcular_precio_final(producto) end)
    end)
    |> Task.await_many()
  end

  def lista_productos do

  [
    %Producto{nombre: "sal", stock: 1, precio_sin_iva: 1000, iva: 0.99},
    %Producto{nombre: "azucar", stock: 2, precio_sin_iva: 2000, iva: 0.99},
    %Producto{nombre: "pimienta", stock: 3, precio_sin_iva: 5500, iva: 0.99},
    %Producto{nombre: "tajin", stock: 4, precio_sin_iva: 8000, iva: 0.99},
  ]
  end

  def iniciar do
    productos = lista_productos()

    precios1 = precios_secuencial(productos)
    IO.puts("\nPrecios SECUENCIAL:")
    Enum.each(precios1, fn {nombre, precio} ->
      IO.puts("  #{nombre}: $#{:erlang.float_to_binary(precio, decimals: 2)}")
    end)
    IO.puts("\n")

    precios2 = precios_concurrencia(productos)
    IO.puts("\nPrecios CONCURRENTE:")
    Enum.each(precios2, fn {nombre, precio} ->
      IO.puts("  #{nombre}: $#{:erlang.float_to_binary(precio, decimals: 2)}")
    end)
    IO.puts("\nCálculo de precios terminado.")
  end
end

Preciosiva.iniciar()
