# Etap 1: Build aplikacji
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Kopiujemy plik projektu i przywracamy zależności
COPY *.csproj ./
RUN dotnet restore

# Kopiujemy resztę kodu źródłowego i publikujemy aplikację
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Etap 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Kopiujemy zbudowaną aplikację
COPY --from=build /app/publish .

# Ustawienia środowiskowe i port
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

# Uruchamiamy aplikację — nazwa DLL musi zgadzać się z projektem
ENTRYPOINT ["dotnet", "HelloWorldApp.dll"]
