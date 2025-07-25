# setup.R - Solo código R
setup_colab_drive <- function() {
  cat("🔧 Iniciando setup de Google Drive...\n")
  
  # Verificar que las credenciales ya existen
  if (!file.exists("credenciales_colab_r.json")) {
    cat("❌ Archivo de credenciales no encontrado\n")
    cat("📋 EJECUTA PRIMERO en una celda Python:\n")
    cat("from google.colab import userdata\n")
    cat("with open('credenciales_colab_r.json', 'w') as f:\n")
    cat("    f.write(userdata.get('credenciales_servicio'))\n")
    stop("Ejecuta el código Python primero")
  }
  
  # Solo código R desde aquí
  packages <- c("googledrive", "googlesheets4", "readxl")
  invisible(lapply(packages, function(pkg) {
    if (!require(pkg, character.only = TRUE)) {
      install.packages(pkg, quiet = TRUE)
      library(pkg, character.only = TRUE)
    }
  }))
  
  drive_auth(path = "credenciales_colab_r.json")
  gs4_auth(path = "credenciales_colab_r.json")
  
  cat("🚀 Setup R completo!\n")
  cat("📧 Usuario:", drive_user()$emailAddress, "\n")
}

# Funciones útiles
cargar_excel <- function(archivo_id, nombre = "datos.xlsx") {
  drive_download(as_id(archivo_id), path = nombre, overwrite = TRUE)
  read_excel(nombre)
}

# Ejecutar setup
setup_colab_drive()
