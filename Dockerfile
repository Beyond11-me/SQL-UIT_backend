# Sử dụng Python 3.10 (hoặc bản bạn đang dùng)
FROM python:3.10-slim

# Cài đặt các thư viện hệ thống cần thiết cho pyodbc và SQL Server
RUN apt-get update && apt-get install -y \
    curl apt-transport-https gnupg2 unixodbc-dev \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && apt-get clean -y

# Đặt thư mục làm việc
WORKDIR /app

# Copy code vào container
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Mở port (Render sẽ truyền biến môi trường PORT vào)
EXPOSE 10000

# Lệnh khởi động FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "10000"]