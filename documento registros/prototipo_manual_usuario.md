# Manual de usuario

## Sistema de control de insumos – Consultorio Santa María Josefa

Elaborado por Tamara Martínez y Álvaro Neira · Taller de Bases de Datos (NRC PRO202), AIEP · Actividad Aprendizaje + Servicio · Octubre 2026

---

## 1. ¿Para qué sirve este sistema?

Este sistema reemplaza el cuaderno de papel donde se anotaban los insumos (gasas, jeringas, guantes, etc.). Sirve para tres cosas muy simples:

1. **Anotar** qué insumos llegan al consultorio y cuáles se usan en cada atención.
2. **Avisar** cuando un insumo se está acabando o está por vencer.
3. **Mostrar reportes** de cuánto se usa en cada box, especialidad y profesional.

No necesita saber de computación. Si sabe usar un formulario o enviar un correo, puede usar este sistema.

## 2. Antes de empezar

- Abra el sistema desde el navegador del computador (Chrome, Edge o Firefox).
- Todo se hace con el mouse y el teclado: botones grandes, listas para elegir y casillas para escribir números.
- El **menú lateral** (a la izquierda) siempre está visible. Desde ahí se llega a todas las pantallas.

**El menú lateral tiene 5 opciones:**

| Opción | ¿Cuándo se usa? |
| --- | --- |
| Registrar consulta | Después de cada atención, para anotar qué insumos se usaron |
| Ingreso de insumos | Cuando llegan insumos nuevos (compra o donación) |
| Salida de insumos | Cuando se retira un insumo que no se usó en consulta (vencido, dañado o ajuste de conteo) |
| Alertas | Para ver qué insumos hay que reponer o usar pronto |
| Reportes | Para revisar y descargar el consumo en PDF |

## 3. Registrar una consulta (insumos usados)

**¿Cuándo?** Al terminar una atención, cuando el profesional usó insumos.

**Pasos:**

1. En el menú lateral, haga clic en **Registrar consulta**.
2. Elija el **box** donde se hizo la atención.
3. Elija el **profesional** que atendió.
4. Revise la **fecha** (normalmente es la de hoy).
5. Escriba el **motivo** de la atención en pocas palabras (por ejemplo: "curación" o "vacunación").
6. Elija el **insumo** de la lista y escriba la **cantidad** usada.
7. Si usó más de un insumo, haga clic en **Agregar otro insumo** y repita el paso 6.
8. Haga clic en **Guardar**.

**Resultado:** el sistema descuenta solo la cantidad del stock. No hay que hacer ninguna resta a mano.

> Consejo: registre la consulta apenas termine, así no se olvidan los insumos usados.

## 4. Ingreso de insumos (cuando llega mercadería)

**¿Cuándo?** Cada vez que llegan insumos al almacén, ya sea comprados o donados.

**Pasos:**

1. Haga clic en **Ingreso de insumos**.
2. Elija el **proveedor** (o el origen, si es una donación).
3. Elija si es **compra** o **donación**.
4. Revise la **fecha de ingreso**.
5. Elija el **insumo** y escriba la **cantidad** que llegó.
6. Para anotar más insumos de la misma entrega, use **Agregar otro insumo**.
7. Si quiere dejar un comentario, escríbalo en **Observación** (por ejemplo: "caja con envase dañado").
8. Haga clic en **Guardar**.

**Resultado:** el stock del insumo sube automáticamente.

## 5. Salida de insumos (retiros que no son por consulta)

**¿Cuándo?** Cuando hay que sacar insumos del stock por una razón distinta a una atención:

- **Vencimiento:** el insumo pasó su fecha y no se puede usar.
- **Merma:** se rompió, se dañó o se perdió.
- **Ajuste de conteo:** al contar físicamente, la cantidad real es distinta a la que muestra el sistema.

**Pasos:**

1. Haga clic en **Salida de insumos**.
2. Elija el **motivo** de la salida.
3. Elija el **insumo** y escriba la **cantidad**.
4. Haga clic en **Guardar**.

**Resultado:** el stock queda al día y coincide con lo que hay realmente en el almacén.

## 6. Alertas (qué hay que reponer o revisar)

El sistema revisa solo el stock y las fechas de vencimiento. No hace falta hacer nada para que funcione.

**Hay dos tipos de alerta:**

| Tipo | ¿Qué significa? |
| --- | --- |
| **Stock mínimo** | Quedan pocas unidades. Hay que pedir más. |
| **Vencimiento próximo** | El insumo vence pronto (el sistema avisa con 30 días de anticipación). Conviene usarlo primero. |

**Cada alerta tiene un estado:**

- **Pendiente:** recién se generó y nadie la ha visto.
- **Notificada:** ya se envió el aviso (por correo) al personal o al proveedor.
- **Resuelta:** el problema se solucionó (llegó stock nuevo, por ejemplo).
- **Descartada:** se revisó y no hace falta hacer nada.

**¿Qué hacer cuando hay una alerta?**

1. Haga clic en **Alertas** y revise la lista.
2. Si es de **stock mínimo**, haga el pedido al proveedor.
3. Si es de **vencimiento**, use ese insumo primero o planifique retirarlo.
4. Cuando lleguen insumos nuevos, regístrelos en **Ingreso de insumos**. La alerta de stock se resuelve sola.

## 7. Reportes (cuánto se usa)

**¿Para qué sirven?** Para saber cuántos insumos se gastan y planificar mejor las compras.

**Pasos:**

1. Haga clic en **Reportes**.
2. Elija qué reporte quiere ver:
   - **Por box:** qué insumos se usaron en cada box.
   - **Por especialidad:** qué insumos usa cada especialidad.
   - **Por profesional:** qué insumos usó cada profesional.
3. Elija el rango de **fechas** (por ejemplo: el último mes).
4. Haga clic en **Ver reporte**.
5. Si necesita guardarlo o imprimirlo, haga clic en **Descargar PDF**.

## 8. Preguntas frecuentes

**Me equivoqué en la cantidad. ¿Qué hago?**
Avise a la persona encargada del sistema para que corrija el registro. Si el stock quedó distinto a lo real, haga una salida por **ajuste de conteo**.

**No encuentro un insumo en la lista.**
Es un insumo nuevo que aún no está creado en el sistema. Avise a la persona encargada para que lo agregue.

**El stock que muestra el sistema no coincide con lo que hay en el almacén.**
Cuente físicamente y registre la diferencia en **Salida de insumos** con el motivo **ajuste de conteo**.

**¿Pueden usar el sistema varias personas a la vez?**
Sí. Cada persona registra lo suyo y el stock se actualiza para todos.

## 9. Buenas prácticas

- Registre los insumos **el mismo día**.
- Cuando lleguen insumos nuevos, revise la **fecha de vencimiento**.
- Una vez por semana, revise la pantalla de **Alertas**.
- Una vez al mes, haga un **conteo físico** y compárelo con el sistema.
- Antes de cerrar, confirme que apareció el mensaje de **guardado**.

## 10. Si necesita ayuda

Si algo no funciona o tiene dudas, contacte al equipo que desarrolló el sistema:

- Tamara Martínez – [correo o teléfono]
- Álvaro Neira – [correo o teléfono]

---

*Este manual se puede imprimir y dejar junto al computador. Si el sistema cambia o se le agregan nuevas funciones, se actualizará esta guía.*
