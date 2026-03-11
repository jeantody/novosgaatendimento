ARG BASE_IMAGE=novosga/novosga:2.2-standalone
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title="novosga-custom-usability"
LABEL org.opencontainers.image.description="NovoSGA image with attendance and triage usability customizations."
LABEL org.opencontainers.image.source="https://github.com/jeantody/novosgaatendimento"

# Overlay only the custom bundles to keep the runtime image close to upstream.
COPY --chown=www-data:www-data attendance-bundle /var/www/html/vendor/novosga/attendance-bundle
COPY --chown=www-data:www-data triage-bundle /var/www/html/vendor/novosga/triage-bundle
