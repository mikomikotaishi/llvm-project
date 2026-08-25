// The memref descriptor fields use the converted index type, which is not
// necessarily `i64`. `convert-vector-to-llvm` has no index bitwidth option, so
// drive the vector patterns through a pass that configures a 32-bit index.

// RUN: mlir-opt %s -convert-gpu-to-nvvm='index-bitwidth=32' | FileCheck %s

gpu.module @m {
  // CHECK-LABEL: llvm.func @type_cast
  //       CHECK:   %[[OFFSET:.*]] = llvm.mlir.constant(0 : index) : i32
  //       CHECK:   llvm.insertvalue %[[OFFSET]], %{{.*}}[2] : !llvm.struct<(ptr, ptr, i32)>
  gpu.func @type_cast(%arg0: memref<8x8x8xf32>) -> memref<vector<8x8x8xf32>> {
    %0 = vector.type_cast %arg0 : memref<8x8x8xf32> to memref<vector<8x8x8xf32>>
    gpu.return %0 : memref<vector<8x8x8xf32>>
  }
}
