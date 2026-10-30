#[derive(Debug)]
pub enum Error {
    NotEnoughEntries,
    NoMin,
    NoMax,
}
pub fn minmax<T: Ord>(numbers: &[T]) -> Result<(&T, &T), Error> {
    if numbers.iter().count() < 2 {
        Err(Error::NotEnoughEntries)
    } else {
        let min = numbers.iter().min();
        let max = numbers.iter().max();
        match (min, max) {
            (Some(lo), Some(hi)) => Ok((lo, hi)),
            (None, None) => Err(Error::NotEnoughEntries),
            (None, Some(_)) => Err(Error::NoMin),
            (Some(_), None) => Err(Error::NoMax),
        }
    }
}
