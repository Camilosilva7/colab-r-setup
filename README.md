# colab-r-setup

# Colab R Setup 🚀

Configuración automática para usar Google Drive y Google Sheets desde R en Google Colab, sin autenticación manual repetitiva.

## Configuración inicial (una sola vez)

### 1. Crear cuenta de servicio
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un proyecto
3. Habilita APIs: Google Drive API y Google Sheets API
4. Crea cuenta de servicio
5. Descarga archivo JSON de credenciales

### 2. Configurar secreto en Colab
1. En Colab, ve al panel izquierdo → 🔑 **Secrets**
2. Crea secreto llamado: `credenciales_servicio`
3. Pega todo el contenido del archivo JSON como valor

### 3. Compartir archivos
Comparte tus archivos de Google Drive con el email de la cuenta de servicio (está en el JSON: `client_email`).

## Uso diario

En cada nuevo cuaderno de Colab:

### Celda 1 (Python) - Crear credenciales:
```python
from google.colab import userdata
credentials_json = userdata.get('credenciales_servicio')
with open('credenciales_colab_r.json', 'w') as f:
    f.write(credentials_json)
print("✅ Credenciales creadas")
```
**IMPORTANTE: CAMBIAR A ENTORNO DE EJECUCIÓN DE R**

### Celda 2 (R) - Setup automático:
```r
source("https://raw.githubusercontent.com/TU_USUARIO_GITHUB/colab-r-setup/main/setup.R")
```

### Celda 3 (R) - ¡Ya puedes trabajar!
```r
# Leer Excel desde Drive
datos <- cargar_excel("tu_archivo_id")

# O leer Google Sheet
datos <- cargar_sheet("tu_sheet_id")

# Ver archivos disponibles
listar_archivos()
```

## Funciones incluidas

El setup instala automáticamente estos paquetes y funciones:

### 📦 Paquetes:
- `googledrive` - Para acceder a Google Drive
- `googlesheets4` - Para leer Google Sheets
- `readxl` - Para leer archivos Excel
- `dplyr` - Para manipulación de datos

### 🔧 Funciones útiles:
- `cargar_excel(archivo_id)` - Descarga y lee archivo Excel
- `cargar_sheet(sheet_id)` - Lee Google Sheet directamente
- `listar_archivos()` - Muestra archivos accesibles
- `setup_colab_drive()` - Re-ejecuta el setup si es necesario

## Obtener IDs de archivos

### Para Google Drive:
1. Abre el archivo en Drive
2. Copia el ID de la URL: `https://drive.google.com/file/d/`**`1ABC123DEF456`**`/view`

### Para Google Sheets:
1. Abre la hoja en Sheets
2. Copia el ID de la URL: `https://docs.google.com/spreadsheets/d/`**`1ABC123DEF456`**`/edit`

## Ejemplo completo

```r
# Después del setup automático
archivo_id <- "1R4OHoNyDlEdlazlE6h30Ld4Ug8Tzxn42"

# Cargar datos
encuesta <- cargar_excel(archivo_id)
```

## Solución de problemas

### Error: "Archivo de credenciales no encontrado"
- Ejecuta primero la celda Python para crear las credenciales
- Verifica que aprobaste el acceso a secretos cuando apareció el popup

### Error: "0 archivos disponibles"
- Comparte tus archivos con el email de la cuenta de servicio
- El email está en el JSON: busca `"client_email"`

### Error: "API not enabled"
- Ve a Google Cloud Console
- Habilita Google Drive API y Google Sheets API en tu proyecto

## Ventajas

✅ **Rápido**: 2 líneas vs. múltiples celdas  
✅ **Seguro**: Credenciales protegidas en secretos  
✅ **Reproducible**: Mismo setup en cualquier cuaderno  
✅ **Actualizable**: Cambios automáticos desde GitHub  
✅ **Sin ventanas**: No más popups de autenticación  

---
