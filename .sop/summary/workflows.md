# Workflows

## Content Authoring Workflow

```mermaid
sequenceDiagram
    participant Author
    participant Hugo as Hugo CLI
    participant FS as Filesystem
    participant Browser

    Author->>Hugo: hugo new content/post-name.md
    Hugo->>FS: Create from archetypes/default.md
    Author->>FS: Edit Markdown + front matter
    Author->>Hugo: hugo server
    Hugo->>Browser: Live reload preview
    Author->>FS: Finalize content (draft: false)
    Author->>FS: git commit + push to main
```

### Steps

1. Create new post: `hugo new content/topic.sequence.subtitle.md`
2. Edit the generated file — set `draft: false` when ready
3. Preview locally: `hugo server` (live reload)
4. Commit and push to `main` to trigger deployment

## Build Workflow

```mermaid
graph LR
    subgraph "Input"
        A[Markdown] --> D[Hugo]
        B[Templates] --> D
        C[CSS Modules] --> E[PostCSS]
        E --> D
        F[config.toml] --> D
    end

    subgraph "Processing"
        D --> G[Render HTML]
        D --> H[Concat + Minify + Fingerprint CSS]
        D --> I[Copy Static Assets]
    end

    subgraph "Output"
        G --> J[public/]
        H --> J
        I --> J
    end
```

### Local Build

```bash
hugo --minify
```

### Local Development Server

```bash
hugo server
```

## Deployment Workflow

```mermaid
graph TD
    A[Push to main] --> B[GitHub Actions triggered]
    B --> C[Checkout repo + submodules]
    C --> D[Install Hugo extended]
    D --> E["hugo --minify"]
    E --> F[Deploy public/ to gh-pages branch]
    F --> G[GitHub Pages serves site]
```

Triggered automatically on push to `main`. Pull requests trigger the build but not the deploy step.

## Adding Images Workflow

1. Place image file in `static/img/` (or as a page resource alongside the content file)
2. Reference in Markdown using the `image` shortcode:

    ```text
    {{< image src="filename.png" alt="Description" caption="Optional" >}}
    ```

3. For multiple images, use the `image-grid` shortcode:

    ```text
    {{< image-grid images="img1.png, img2.png, img3.png" >}}
    ```

## CSS Modification Workflow

1. Edit the relevant module in `assets/css/` (e.g., `typography.css`)
2. Hugo Pipes automatically picks up changes during `hugo server`
3. The pipeline concatenates, minifies, and fingerprints the output
4. No manual build step needed for CSS — Hugo handles it

## Adding a New CSS Module

1. Create `assets/css/newmodule.css`
2. Add `@import "newmodule.css";` to `assets/css/main.css`
3. Add `{{ $newmodule := resources.Get "css/newmodule.css" }}` in `baseof.html`
4. Add `$newmodule` to the `slice` in the `resources.Concat` call
