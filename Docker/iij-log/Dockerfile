#FROM public.ecr.aws/lambda/python:3.12
FROM mcr.microsoft.com/playwright/python:v1.45.0-jammy

ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

COPY requirements.txt ${LAMBDA_TASK_ROOT}

RUN pip install awslambdaric

RUN pip install -r requirements.txt

RUN playwright install chromium

RUN ls -R /ms-playwright

COPY lambda_function.py ${LAMBDA_TASK_ROOT}

ENTRYPOINT [ "/usr/bin/python", "-m", "awslambdaric" ]
CMD ["lambda_function.lambda_handler"]

