zap-full-scan:
  stage: scan
  image:
    name: zaproxy/zap-stable:2.15.0
    entrypoint: [""]
  variables:
    CI_PROJECT_DIR: /zap/wrk
    ZAP_ALERT_REPORT: quick_scan_alert_report
    ZAP_REPORT: quick_scan_report
  script:
    - echo "Copying files from /zap to /zap/wrk..."
    - mkdir -p /zap/wrk  # Garante que o diretório /zap/wrk exista
    - cp -r /zap/* /zap/wrk/
    - echo "Running OWASP ZAP scan..."
    - bash /zap/zap_full_scan.sh
    - echo "Listing files in /zap/wrk/..."
    - ls -l /zap/wrk/
    - echo "Displaying content of quick_scan_alert_report.md..."
    - cat /zap/wrk/quick_scan_alert_report.md || echo "quick_scan_alert_report.md not found"
  only:
    refs:
      - branches
  artifacts:
    when: always
    expire_in: 1 week
    paths:
      - wrk/quick_scan_report.html
      - wrk/quick_scan_alert_report.md

