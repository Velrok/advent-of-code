import gleam/dict.{type Dict}
import gleam/list

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
