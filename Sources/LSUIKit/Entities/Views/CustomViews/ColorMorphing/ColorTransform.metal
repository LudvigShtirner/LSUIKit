#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float4 colorA;
    float4 colorB;
    float progress;
};

vertex float4 vertex_main(const device float2* vertexArray [[ buffer(0) ]],
                          uint vid [[ vertex_id ]]) {
    return float4(vertexArray[vid], 0.0, 1.0);
}

fragment float4 fragment_main(const constant Uniforms& uniforms [[ buffer(1) ]]) {
    return mix(uniforms.colorA, uniforms.colorB, uniforms.progress);
}
