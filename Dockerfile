FROM zaproxy/zap-stable:2.15.0

WORKDIR /zap/wrk

EXPOSE 8080

CMD ["zap-baseline.py", "-t", "https://a2ff-24-152-27-101.ngrok-free.app/", "-r", "/zap/wrk/scan-report.html"]

