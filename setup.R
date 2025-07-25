# setup.R - Configuración automática para Google Colab + R
# Uso: source("https://raw.githubusercontent.com/TU-USUARIO/colab-r-setup/main/setup.R")

setup_colab_drive <- function() {
  cat("🔧 Iniciando setup de Google Drive para Colab...\n")
  
  # Crear credenciales desde secreto
  cat("📋 Creando credenciales desde secreto...\n")
  system("python3 -c \"
from google.colab import userdata
try:
    with open('credenciales_colab_r.json', 'w') as f:
        f.write(userdata.get('credenciales_servicio'))
    print('✅ Credenciales creadas exitosamente')
except Exception as e:
    print('❌ Error:', str(e))
    print('⚠️ Asegúrate de aprobar el acceso a secretos')
\"")
  
  # Verificar que el archivo se creó
  if (!file.exists("credenciales_colab_r.json")) {
    stop("❌ No se pudo crear el archivo de credenciales")
  }
  
  # Instalar y cargar paquetes
  cat("📦 Instalando paquetes necesarios...\n")
  packages <- c("googledrive", "googlesheets4", "readxl", "dplyr")
  
  invisible(lapply(packages, function(pkg) {
    if (!require(pkg, character.only = TRUE)) {
      cat("  📥 Instalando", pkg, "...\n")
      install.packages(pkg, quiet = TRUE, repos = "https://cran.rstudio.com/")
      library(pkg, character.only = TRUE)
    } else {
      cat("  ✅", pkg, "ya instalado\n")
    }
  }))
  
  # Autenticación
  cat("🔐 Configurando autenticación...\n")
  drive_auth(path = "credenciales_colab_r.json")
  gs4_auth(path = "credenciales_colab_r.json")
  
  # Verificación
  cat("🚀 Setup completo!\n")
  cat("📧 Conectado como:", drive_user()$emailAddress, "\n")
  cat("📊 Archivos disponibles:", nrow(drive_ls()), "\n")
  
  return(invisible(TRUE))
}

# Funciones útiles adicionales
cargar_excel <- function(archivo_id, nombre = "datos.xlsx") {
  cat("📥 Descargando archivo Excel...\n")
  drive_download(as_id(archivo_id), path = nombre, overwrite = TRUE)
  datos <- read_excel(nombre)
  cat("✅ Archivo cargado:", nrow(datos), "filas x", ncol(datos), "columnas\n")
  return(datos)
}

cargar_sheet <- function(sheet_id) {
  cat("📊 Leyendo Google Sheet...\n")
  datos <- read_sheet(sheet_id)
  cat("✅ Sheet cargado:", nrow(datos), "filas x", ncol(datos), "columnas\n")
  return(datos)
}

listar_archivos <- function() {
  archivos <- drive_ls()
  cat("📁 Archivos disponibles:\n")
  print(archivos[c("name", "id")])
  return(archivos)
}

# Ejecutar setup automáticamente al cargar
cat("🚀 Ejecutando setup automático...\n")
setup_colab_drive()

# Mostrar funciones disponibles
cat("\n📚 Funciones disponibles:\n")
cat("  • cargar_excel('archivo_id')\n")
cat("  • cargar_sheet('sheet_id')\n") 
cat("  • listar_archivos()\n")
cat("  • setup_colab_drive() # para re-ejecutar setup\n")
