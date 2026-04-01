# Documentation

This directory contains the MkDocs-based documentation for the workspace infrastructure and applications.

## Quick Start

### Prerequisites
- Python 3.8 or higher
- pip package manager

### Local Development

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Serve locally:**
   ```bash
   mkdocs serve
   ```
   
   The documentation will be available at `http://127.0.0.1:8000`

3. **Build static site:**
   ```bash
   mkdocs build
   ```

### Project Structure

```
docs/
├── mkdocs.yml          # MkDocs configuration
├── requirements.txt    # Python dependencies
├── index.md           # Homepage
├── architecture/      # System architecture docs
├── kubernetes/        # Kubernetes cluster docs
├── proxmox/          # Proxmox virtualization docs
├── studies/          # Learning materials
├── workshops/        # Training materials
└── resources/        # Images and assets
```

## Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch. See `.github/workflows/docs.yml` for the deployment configuration.

## Writing Documentation

- Use Markdown format for all content
- Place images in `resources/images/`
- Follow the existing navigation structure in `mkdocs.yml`
- Test locally before committing changes

## Theme and Features

The documentation uses the Material theme for MkDocs with the following features:
- Dark/light mode toggle
- Search functionality
- Navigation tabs
- Code highlighting
- Admonitions and callouts
- Git revision dates

## Contributing

1. Make changes to the documentation files
2. Test locally with `mkdocs serve`
3. Commit and push changes
4. Documentation will be automatically deployed to GitHub Pages