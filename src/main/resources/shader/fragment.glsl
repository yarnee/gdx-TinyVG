#ifdef GL_ES
precision mediump float;
#endif

const float gamma = 2.2;

varying vec4 v_color;
varying vec2 v_texCoords;

uniform vec4 u_startColor;
uniform vec4 u_endColor;

uniform vec2 u_startPosition;
uniform vec2 u_endPosition;
uniform vec2 u_resolution;

uniform int u_style;

uniform sampler2D u_texture;

vec2 getProjectedPointOnLine(vec2 v1, vec2 v2, vec2 p)
{
    // get dot product of e1, e2
    vec2 e1 = v2 - v1;
    vec2 e2 = p - v1;
    float valDp = dot(e1, e2);

    // get length of vectors
    float lenLineE1 = sqrt(e1.x * e1.x + e1.y * e1.y);
    float lenLineE2 = sqrt(e2.x * e2.x + e2.y * e2.y);
    float cos = valDp / (lenLineE1 * lenLineE2);

    // length of v1P'
    float projLenOfLine = cos * lenLineE2;

    return vec2((v1.x + (projLenOfLine * e1.x) / lenLineE1), (v1.y + (projLenOfLine * e1.y) / lenLineE1));
}

vec4 flatColor() {
    return u_startColor;
}

vec4 linearGradient() {
    vec2 direction = u_endPosition - u_startPosition;
    vec2 delta_pt = gl_FragCoord.xy - u_startPosition;

    if (dot(direction, delta_pt) <= 0.0)
        return u_startColor;

    if (dot(direction, gl_FragCoord.xy - u_endPosition) >= 0.0)
        return u_endColor;

    float len_grad = length(direction);
    float pos_grad = length(getProjectedPointOnLine(vec2(0, 0), direction, delta_pt));

    return mix(u_startColor, u_endColor, pos_grad / len_grad);
}

vec4 radialGradient() {
    float len_total = length(u_startPosition - u_endPosition);
    float len_arc = length(u_startPosition - gl_FragCoord.xy);

    float f = clamp(len_arc, 0, len_total) / len_total;

    return mix(u_startColor, u_endColor, f);
}

vec4 linear2gamma(vec4 color) {
    return vec4(pow(color.rgb, vec3(1.0 / gamma)), color.a);
}

void main() {
    vec4 result;

    switch (u_style)
    {
        case 0:
            result = flatColor();
            break;
        case 1:
            result = linearGradient();
        break;
            case 2:
            result = radialGradient();
            break;
        default:
            result = vec4(1, 0, 1, 1);
            break;
    }

    gl_FragColor = linear2gamma(result);
}