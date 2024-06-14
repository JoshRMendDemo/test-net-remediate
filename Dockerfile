#build container
FROM mcr.microsoft.com/dotnet/sdk:5.0.400-focal as build

WORKDIR /build
COPY . .
RUN dotnet run -p build/build.csproj

#runtime container
FROM mcr.microsoft.com/dotnet/aspnet:5.0.9-alpine3.12
RUN apk add --no-cache tzdata

COPY --from=build /build/publish /app
WORKDIR /app

EXPOSE 5000

# Mend traceability labels
LABEL io.mend.image.dockerfile.path=master/Dockerfile
LABEL org.opencontainers.image.source=https://github.com/JoshRMendDemo/test-net-remediate

ENTRYPOINT ["dotnet", "Conduit.dll"]
