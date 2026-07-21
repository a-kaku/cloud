#FROM public.ecr.aws/lambda/python:3.12
FROM mcr.microsoft.com/playwright/python:v1.45.0-jammy

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip install awslambdaric

RUN pip install -r requirements.txt

# Chromium dependencies
#RUN dnf install -y \
#    nspr \
#    nss \
#    atk \
#    cups-libs \
#    libdrm \
#    libXcomposite \
#    libXdamage \
#    libXrandr \
#    mesa-libgbm \
#    pango \
#    alsa-lib \
#    gtk3 \
#    libxkbcommon \
#    libX11-xcb \
#    libXScrnSaver libXtst libXrender libXi libXfixes freetype fontconfig    
#    && dnf clean all

RUN playwright install chromium

RUN ls -R /ms-playwright

COPY lambda_function.py ${LAMBDA_TASK_ROOT}

#CMD ["lambda_function.lambda_handler"]
ENTRYPOINT [ "/usr/bin/python", "-m", "awslambdaric" ]
CMD ["lambda_function.lambda_handler"]

