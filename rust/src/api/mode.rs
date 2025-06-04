#[repr(C)]
#[derive(Copy, Clone, Debug, PartialEq)]
pub enum MldsaMode {
    Mldsa44,
    Mldsa65,
    Mldsa87,
}