FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ./Catalog.API .
RUN dotnet restore -nowarn:msb3202,nu1503
RUN dotnet build --no-restore -c Release -o /app

FROM build AS publish
RUN dotnet publish --no-restore -c Release -o /app

FROM base AS final
RUN apt-get update && apt-get install -y iputils-ping
WORKDIR /app
COPY --from=publish /app .
EXPOSE 80 5000
ENTRYPOINT ["dotnet", "Catalog.API.dll"]