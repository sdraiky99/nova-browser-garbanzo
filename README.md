# Nova Browser

Navegador basado en **Floorp** (Gecko / Firefox). Nova no recompila el motor: coge la última versión estable de Floorp, le aplica la capa Nova (interfaz, nueva pestaña, bienvenida, políticas) y genera un instalador `Nova-Setup-X.Y.Z.exe` con GitHub Actions.

## Qué incluye (v0.1.0)
- `+` de pestañas pegado a la última pestaña, con animación, y barra translúcida (Aero/Mica).
- Nueva pestaña limpia estilo Aero y bienvenida con mini tutorial de 4 pasos.
- Extensiones de Firefox, F12, marcadores, historial, zoom y vista dividida (los aporta Floorp/Firefox).
- Instalador con presentación animada y opciones (escritorio, menú Inicio, abrir Ajustes de Windows para el predeterminado). Se instala sin administrador.
- Perfil propio en `%APPDATA%\Nova\Profile` (no mezcla datos con Floorp).
- Web de descargas en `docs/` (lee las Releases del repo automáticamente).
- `account-server/`: servidor de cuentas de tu Nova anterior, como punto de partida para la cuenta Nova real (fase posterior).

## Cómo ponerlo en GitHub (solo desde la web, sin CMD ni administrador)
1. Crea un repositorio **público** nuevo (por ejemplo `nova-browser`).
2. Descomprime este zip. En el repo: **Add file → Upload files** y arrastra el *contenido* de la carpeta (no la carpeta). Confirma con **Commit changes**.
3. Comprueba que existe `.github/workflows/build.yml`. Si no se subió (las carpetas con punto a veces fallan): **Add file → Create new file**, nombre `.github/workflows/build.yml`, y pega el contenido de `COPIA-build.yml`.
4. **Settings → Actions → General → Workflow permissions → Read and write permissions → Save**.
5. Pestaña **Actions → Build Nova → Run workflow**. Tarda unos minutos.
6. Cuando esté en verde, ve a **Releases**: ahí está `Nova-Setup-0.1.0.exe`.
7. Web de descargas: **Settings → Pages → Branch `main` / carpeta `/docs` → Save**. Quedará en `https://TU-USUARIO.github.io/nova-browser/`.

Para sacar una versión nueva, cambia el número en el archivo `VERSION` y vuelve a ejecutar el workflow.

## Si algo falla (lo más probable)
Este paquete no se ha podido ejecutar contra Floorp real al crearlo. Si el workflow sale en rojo, copia el texto rojo del paso que falla. Los puntos más delicados son:
- **Extracción de Floorp** (`7z x ... -ir!core`): depende del nombre del instalador oficial `floorp-win64.installer.exe`.
- **`nova.cfg`**: si la nueva pestaña o los estilos no cambian, hay que ajustar las rutas/módulos a la versión de Floorp.
- **`nova.css`**: los selectores de la barra de pestañas pueden necesitar retoques según la versión.
- El paso del icono (rcedit) es opcional y no detiene la compilación.

## Pendiente (siguientes fases)
- Rebrand completo (nombre en la ventana, «Acerca de», logo en todos los sitios): requiere fork del código fuente de Floorp.
- Cuenta Nova real con sincronización y contraseñas: backend propio, cifrado de extremo a extremo y RGPD.
- Firma de código del `.exe` (sin ella, Windows SmartScreen avisará).

## Créditos y licencia
Nova se construye sobre Floorp (MPL-2.0) y Mozilla Firefox. Nova no está afiliado con Floorp ni con Mozilla. «Floorp» es marca de sus autores y su logo está protegido: Nova usa nombre e icono propios. Los archivos añadidos por Nova se publican bajo MPL-2.0.
