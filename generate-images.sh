#!/usr/bin/env bash
set -euo pipefail

# Get API key from pass
OPENAI_API_KEY=$(pass show development/ai/bethelservice-4)
API_URL="https://aigw.bethelservice.org/v1/images/generations"

# Output directory - Hugo static folder
OUTPUT_DIR="static/img"
mkdir -p "$OUTPUT_DIR"

# Function to generate image
generate_image() {
    local prompt="$1"
    local filename="$2"
    
    echo "Generating: $filename"
    echo "Prompt: $prompt"
    
    response=$(curl -s "$API_URL" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "{
            \"model\": \"azure_ai/flux.1-kontext-pro\",
            \"prompt\": \"$prompt\",
            \"response_format\": \"b64_json\"
        }")
    
    # Extract base64 image data from response
    image_data=$(echo "$response" | jq -r '.data[0].b64_json // empty')
    
    if [ -z "$image_data" ]; then
        echo "Error: No image data in response"
        echo "$response" | jq '.'
        return 1
    fi
    
    # Decode base64 and save image
    echo "$image_data" | base64 -d > "$OUTPUT_DIR/$filename"
    echo "✓ Saved: $OUTPUT_DIR/$filename"
    echo ""
}

# Base style description for consistency
BASE_STYLE="terminal-style, Rosé Pine Moon color palette (dark purple #232136 background, cyan #9ccfd8 accents, pink #eb6f92 highlights), minimalist, flat design, developer aesthetic"

echo "=== Generating Website Images ==="
echo ""

# 1. Master icon/logo (base for all favicons)
generate_image \
    "circular icon, terminal prompt symbol (>_) in center, $BASE_STYLE, 1024x1024, clean vector style, monogram AS integrated subtly" \
    "master-icon.png"

# 2. Favicon variations (will need manual resizing from master-icon.png)
echo "Note: Resize master-icon.png to create favicon files in static/"

# 3. Open Graph / Social Media image
generate_image \
    "website banner, terminal window mockup showing code editor, $BASE_STYLE, 1200x630, text 'abrahamsustaita.com' in terminal font, developer workspace aesthetic" \
    "og-image.png"

# 4. Hero background
generate_image \
    "abstract geometric pattern, subtle grid lines, $BASE_STYLE, 1920x1080, very subtle, low contrast, background texture for hero section" \
    "hero-bg.webp"

# 5. Developer illustration
generate_image \
    "minimalist illustration of developer at terminal, $BASE_STYLE, 800x600, flat vector style, side view, glowing screen, cozy workspace" \
    "developer-illustration.webp"

# 6. Blog placeholder
generate_image \
    "abstract code snippet visualization, $BASE_STYLE, 1200x630, terminal window with colorful syntax highlighting, minimalist composition" \
    "blog-placeholder.webp"

# 7. Pattern grid
generate_image \
    "seamless tileable pattern, subtle grid dots, $BASE_STYLE, 512x512, very minimal, low opacity, background texture" \
    "pattern-grid.webp"

# 8. Logo SVG (text-based, will need manual creation)
echo "Note: Create logo.svg manually with 'AS' monogram or 'abrahamsustaita.com' text"
echo "      Use Rosé Pine colors: --text: #e0def4, --iris: #c4a7e7, --foam: #9ccfd8"

echo ""
echo "=== Generation Complete ==="
echo "Images saved to: $OUTPUT_DIR/"
echo ""
echo "Manual steps needed:"
echo "1. Resize master-icon.png to create favicons in static/:"
echo "   cd static/img"
echo "   convert master-icon.png -resize 16x16 ../favicon-16x16.png"
echo "   convert master-icon.png -resize 32x32 ../favicon-32x32.png"
echo "   convert master-icon.png -resize 180x180 ../apple-touch-icon.png"
echo "   convert master-icon.png \\( -clone 0 -resize 16x16 \\) \\( -clone 0 -resize 32x32 \\) \\( -clone 0 -resize 48x48 \\) -delete 0 ../favicon.ico"
echo ""
echo "2. Create SVG logos manually (logo.svg, logo-dark.svg, logo-light.svg)"
echo "   Use Rosé Pine colors: --text: #e0def4, --iris: #c4a7e7, --foam: #9ccfd8"
