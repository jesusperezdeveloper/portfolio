# Plan: Conectar dominio Cloudflare a Firebase Hosting

## Resumen Ejecutivo

Conectar el dominio `www.jpsdeveloper.com` gestionado en Cloudflare al proyecto Firebase `jpsdeveloper-portfolio`.

**Proyecto Firebase:** `jpsdeveloper-portfolio`
**Dominio:** `www.jpsdeveloper.com` (y `jpsdeveloper.com`)

---

## Fase 1: Configurar dominio en Firebase Console

### Paso 1.1: Acceder a Firebase Hosting
- [ ] Ir a [Firebase Console](https://console.firebase.google.com)
- [ ] Seleccionar proyecto `jpsdeveloper-portfolio`
- [ ] Navegar a **Hosting** en el menú lateral

### Paso 1.2: Añadir dominio personalizado
- [ ] Clic en **"Agregar dominio personalizado"**
- [ ] Introducir `jpsdeveloper.com` (dominio raíz primero)
- [ ] Firebase mostrará registros DNS necesarios (tipo A o TXT para verificación)

### Paso 1.3: Obtener registros DNS de Firebase
Firebase proporcionará:
```
Registro TXT para verificación:
Tipo: TXT
Nombre: @
Valor: firebase-verification-xxxxx

Registros A (después de verificación):
Tipo: A
Nombre: @
Valor: 151.101.1.195
Valor: 151.101.65.195
```

---

## Fase 2: Configurar DNS en Cloudflare

### Paso 2.1: Acceder a Cloudflare
- [ ] Ir a [Cloudflare Dashboard](https://dash.cloudflare.com)
- [ ] Seleccionar el dominio `jpsdeveloper.com`
- [ ] Navegar a la pestaña **DNS**

### Paso 2.2: Añadir registro TXT de verificación
- [ ] Clic en **"Add record"**
- [ ] Configurar:
  - **Type:** TXT
  - **Name:** @ (o dejar vacío)
  - **Content:** El valor proporcionado por Firebase
  - **Proxy status:** DNS only (nube gris)
- [ ] Guardar

### Paso 2.3: Verificar en Firebase
- [ ] Volver a Firebase Console
- [ ] Clic en **"Verificar"**
- [ ] Esperar confirmación (puede tardar minutos)

### Paso 2.4: Añadir registros A en Cloudflare
Una vez verificado, añadir los registros A:

- [ ] **Primer registro A:**
  - Type: A
  - Name: @
  - IPv4: `151.101.1.195`
  - Proxy status: **DNS only** (nube gris) ⚠️ IMPORTANTE

- [ ] **Segundo registro A:**
  - Type: A
  - Name: @
  - IPv4: `151.101.65.195`
  - Proxy status: **DNS only** (nube gris)

### Paso 2.5: Configurar www (subdominio)
- [ ] Volver a Firebase y añadir también `www.jpsdeveloper.com`
- [ ] En Cloudflare añadir:
  - Type: CNAME
  - Name: www
  - Target: `jpsdeveloper-portfolio.web.app`
  - Proxy status: **DNS only** (nube gris)

---

## Fase 3: Configuración SSL/TLS

### Paso 3.1: Configurar SSL en Cloudflare
- [ ] Ir a **SSL/TLS** en Cloudflare
- [ ] Seleccionar modo **"Full"** (NO Full Strict por ahora)
- [ ] Desactivar temporalmente "Always Use HTTPS" si hay problemas

### Paso 3.2: Esperar provisión SSL de Firebase
- [ ] Firebase generará certificado SSL automáticamente
- [ ] Estado cambiará de "Pendiente" a "Conectado"
- [ ] Puede tardar hasta 24 horas (normalmente 1-2 horas)

---

## Fase 4: Configuración final de Cloudflare

### Paso 4.1: Ajustar configuración de proxy (opcional)
Una vez que Firebase tenga SSL activo:
- [ ] **Opción A (Recomendada):** Mantener proxy desactivado (nube gris)
  - Firebase maneja todo (SSL, CDN, caché)
  - Más simple y menos conflictos

- [ ] **Opción B:** Activar proxy de Cloudflare (nube naranja)
  - Requiere SSL modo "Full (strict)"
  - Añade capa extra de CDN
  - Puede causar conflictos con caché

### Paso 4.2: Configurar redirección www
En **Rules > Redirect Rules** de Cloudflare:
- [ ] Crear regla para redirigir `jpsdeveloper.com` → `www.jpsdeveloper.com` (o viceversa)

---

## Fase 5: Verificación

### Paso 5.1: Probar accesos
- [ ] Acceder a `https://jpsdeveloper.com`
- [ ] Acceder a `https://www.jpsdeveloper.com`
- [ ] Verificar que ambos cargan correctamente
- [ ] Verificar certificado SSL (candado verde)

### Paso 5.2: Probar redirecciones
- [ ] `http://jpsdeveloper.com` → debe redirigir a HTTPS
- [ ] `http://www.jpsdeveloper.com` → debe redirigir a HTTPS

---

## Troubleshooting

### Error: "Verificación fallida"
- Esperar 5-10 minutos y reintentar
- Verificar que el registro TXT está correcto
- Asegurar que proxy está desactivado (nube gris)

### Error: "SSL no disponible"
- El certificado de Firebase puede tardar hasta 24h
- Verificar que registros A apuntan a IPs de Firebase
- No usar proxy de Cloudflare hasta que Firebase tenga SSL

### Error: "Too many redirects"
- Desactivar "Always Use HTTPS" en Cloudflare temporalmente
- Verificar modo SSL es "Full" no "Flexible"
- Asegurar proxy desactivado

### Error: "DNS_PROBE_FINISHED_NXDOMAIN"
- Los DNS pueden tardar hasta 48h en propagarse
- Usar [DNS Checker](https://dnschecker.org) para verificar propagación

---

## Resumen de registros DNS finales

| Tipo  | Nombre | Valor                              | Proxy |
|-------|--------|------------------------------------|-------|
| TXT   | @      | firebase-verification-xxxxx        | -     |
| A     | @      | 151.101.1.195                      | Off   |
| A     | @      | 151.101.65.195                     | Off   |
| CNAME | www    | jpsdeveloper-portfolio.web.app     | Off   |

---

## Tiempo estimado
- Configuración: 15-30 minutos
- Propagación DNS: 5 minutos - 48 horas
- SSL de Firebase: 1-24 horas

---

## Comandos útiles

```bash
# Verificar DNS propagación
dig jpsdeveloper.com A
dig www.jpsdeveloper.com CNAME

# Ver estado actual de hosting
firebase hosting:sites:list

# Redesplegar si es necesario
flutter build web --release --web-renderer canvaskit
firebase deploy --only hosting
```
