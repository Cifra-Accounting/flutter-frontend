#version 460

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

uniform float uPixelSize;
uniform float uPixelSpacerSize;
uniform vec4 uPixelColor;
uniform vec4 uBackgroundColor;

uniform sampler2D uTexture;

out vec4 fragColor;


bool isInsidePixel(vec2 uv, vec2 normalPixelSize, vec2 normalPixelSpacerSize) {
    vec2 pixelStep = normalPixelSize + normalPixelSpacerSize;
    vec2 grid = floor(uv / pixelStep);
    vec2 pixelOrigin = grid * pixelStep;
    vec2 local = uv - pixelOrigin;

    return all(lessThan(local, normalPixelSize));
}


vec2 calculateCenterOfPixel(vec2 uv, vec2 normalPixelSize, vec2 normalPixelSpacerSize) {
    vec2 pixelStep = normalPixelSize + normalPixelSpacerSize;
    vec2 grid = floor(uv / pixelStep);
    vec2 pixelOrigin = grid * pixelStep;

    return pixelOrigin + normalPixelSize / 2.0;
}

vec4 getTexColor(vec2 uv) {
    return texture(uTexture, uv);
}

float getLuminance(vec4 color) {
    return dot(color.xyz, vec3(0.299, 0.587, 0.114)) * color.a;
}

float calculatePixelLuminance(vec2 pixelCenter, vec2 normalPixelSize) {
    float result = 0.0;
    for (float i = -6.0; i < 6.0; i++) {
        for (float j = -6.0; j < 6.0; j++) {
            vec2 pos = pixelCenter + vec2(normalPixelSize.x / i, normalPixelSize.y / j);
            vec4 color = getTexColor(pos);
            result += getLuminance(color);
        }
    }

    return result / (12.0 * 12.0);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;

    vec2 normalPixelSize = uPixelSize / uSize;
    vec2 normalPixelSpacerSize = uPixelSpacerSize / uSize;

    if (!isInsidePixel(uv, normalPixelSize, normalPixelSpacerSize)) {
        fragColor = vec4(0.0);
        return;
    }
    vec2 pixelCenter = calculateCenterOfPixel(uv, normalPixelSize, normalPixelSpacerSize);

    float luminance = calculatePixelLuminance(pixelCenter, normalPixelSize);

    float lightFactor = clamp(luminance + 0.1, 0.0, 1.0);
    fragColor = mix(uBackgroundColor, uPixelColor, lightFactor > 0.5 ? lightFactor : 0.0);

}

