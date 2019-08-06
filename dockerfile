FROM microsoft/dotnet:2.2-sdk AS builder
WORKDIR /source
COPY ./src .
RUN dotnet restore
RUN dotnet publish ./SAGE.BR.HyperCube.Hrm.Service.Host --output /app/

FROM microsoft/dotnet:2.2-aspnetcore-runtime-alpine

ENV CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
    CORECLR_NEWRELIC_HOME=/app/newrelic \
    CORECLR_PROFILER_PATH=/app/newrelic/libNewRelicProfiler.so \
    NEW_RELIC_LICENSE_KEY=6fe209976825377ef899578f59efdd10263aa7c6 \
    NEW_RELIC_APP_NAME=local_sage_br_hypercube_hrm_service

WORKDIR /app
COPY --from=builder /app .
EXPOSE 5002
ENTRYPOINT ["dotnet", "SAGE.BR.HyperCube.Hrm.Service.Host.dll"]
