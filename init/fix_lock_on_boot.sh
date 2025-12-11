#!/system/bin/sh
# Esperar a que system esté listo
until [ "$(getprop sys.boot_completed)" = "1" ]; do sleep 2; done

# Eliminar lockscreen
rm -f /data/system/locksettings.db*
rm -f /data/system/gatekeeper.*
rm -f /data/system/*.key

# Crear nuevo locksettings deshabilitado
sqlite3 /data/system/locksettings.db "CREATE TABLE locksettings (name TEXT, value TEXT)"
sqlite3 /data/system/locksettings.db "INSERT INTO locksettings VALUES ('lockscreen.disabled', '1')"
sqlite3 /data/system/locksettings.db "INSERT INTO locksettings VALUES ('lockscreen.password_type', '0')"

# Permisos
chmod 600 /data/system/locksettings.db
chown system:system /data/system/locksettings.db

# Forzar recarga de SystemUI
pkill -f com.android.systemui

# Log
echo "LOCKSCREEN ELIMINADO - $(date)" >> /data/lock_hack.log
