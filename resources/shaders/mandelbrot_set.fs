#version 400

#extension GL_ARB_gpu_shader_fp64 : enable

#define PI 3.1415926535897932384626433832795

// Input vertex attributes (from vertex shader)
in vec2 fragTexCoord;
in vec4 fragColor;

// Output fragment color
out vec4 finalColor;

uniform ivec2 zoom;             // Zoom of the scale
uniform ivec2 offsetR;          // Offset Real (double in bits)
uniform ivec2 offsetI;          // Offset Imaginary (double in bits)
uniform int maxIterations;      // Max iterations per pixel

const double max = 4.0;          // We consider infinite as 4.0: if a point reaches a distance of 4.0 it will escape to infinity
const double max2 = max*max;     // Square of max to avoid computing square root

void main()
{
    dvec2 offset = dvec2(packDouble2x32(offsetR), packDouble2x32(offsetI));
    double zoom_d = packDouble2x32(zoom);

    // The pixel coordinates are scaled so they are on the mandelbrot scale
    // NOTE: fragTexCoord already comes as normalized screen coordinates but offset must be normalized before scaling and zoom
    dvec2 c = dvec2((fragTexCoord.x - 0.5)*2.0f, (fragTexCoord.y - 0.5)*1.25f)/zoom_d;
    c.x += offset.x;
    c.y += offset.y;
    double a = 0.0;
    double b = 0.0;

    // The Mandelbrot set is a two-dimensional set defined in the complex plane on which the iteration of the function
    // Fc(z) = z^2 + c on the complex numbers c from the plane does not diverge to infinity starting at z = 0
    // Here: z = a + bi. Iterations: z -> z^2 + c = (a + bi)^2 + (c.x + c.yi) = (a^2 - b^2 + c.x) + (2ab + c.y)i

    int iter = 0;
    for (iter = 0; iter < maxIterations; ++iter)
    {
        double aa = a*a;
        double bb = b*b;
        if (aa + bb > max2)
            break;

        double twoab = 2.0*a*b;
        a = aa - bb + c.x;
        b = twoab + c.y;
    }

    if (iter >= maxIterations)
    {
        finalColor = vec4(0.0, 0.0, 0.0, 1.0);
    }
    else
    {
        float normR = float(iter%55)/55.0;
        float normG = float(iter%69)/69.0;
        float normB = float(iter%40)/40.0;

        finalColor = vec4(sin(normR*PI), sin(normG*PI), sin(normB*PI), 1.0);
    }
}
