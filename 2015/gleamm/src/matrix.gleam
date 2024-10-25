import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}

pub opaque type Matrix(inner) {
  Matrix(width: Int, height: Int, data: Dict(Int, Dict(Int, inner)))
}

fn init_row(w: Int, default: inner) -> Dict(Int, inner) {
  list.repeat(default, times: w)
  |> list.index_map(fn(element, index) { #(index, element) })
  |> dict.from_list
}

fn init_data(w: Int, h: Int, default: inner) -> Dict(Int, Dict(Int, inner)) {
  list.repeat(default, times: h)
  |> list.index_map(fn(element, index) { #(index, init_row(w, element)) })
  |> dict.from_list
}

pub fn new(width w: Int, height h: Int, nullvalue default: a) {
  Matrix(width: w, height: h, data: init_data(w, h, default))
}

pub fn upsert(
  matrix m: Matrix(inner),
  x x: Int,
  y y: Int,
  with fun: fn(Option(inner)) -> inner,
) -> Matrix(inner) {
  let new_data =
    dict.upsert(m.data, update: y, with: fn(row) {
      case row {
        Some(r) ->
          dict.upsert(r, update: x, with: fn(val_option) { fun(val_option) })
        None -> panic
      }
    })

  Matrix(..m, data: new_data)
}
