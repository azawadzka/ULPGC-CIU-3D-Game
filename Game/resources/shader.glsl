#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

varying vec4 vertColor;
varying vec4 vertTexCoord;

uniform vec2 u_resolution;
uniform vec2 u_face;

uniform float u_zoom;

void main(void) {

    vec4 col4 = texture2D(texture, vertTexCoord.st);

    vec2 face = u_face/u_resolution;

    float dist = distance(vertTexCoord.st, face);


      //  gl_FragColor = vec4(col4.r, col4.g, col4.b, 1.0 - smoothstep(0.8, 1.0, dist * 3.0)) * vertColor;

      float val = 1.0 - smoothstep(0.6, 1.0, dist * u_zoom);

  gl_FragColor = val * col4;
}
