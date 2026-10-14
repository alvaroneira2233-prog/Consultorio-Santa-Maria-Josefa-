# Levantamiento de requerimientos — Consultorio Santa María Josefa

Actividad de Aprendizaje + Servicio · Taller de Base de Datos (AIEP, NRC PRO202)
Equipo: Tamara Martínez y Álvaro Neira

## 1. Datos de la reunión

| Campo | Detalle |
|---|---|
| Fecha | Jueves 1 de octubre de 2026 |
| Modalidad | Presencial |
| Lugar | Consultorio "Santa María Josefa", Gamero 849 |
| Socio comunitario | Madre Manuela Villagra Ríos (representante legal) |
| Equipo A+S | Tamara Martínez, Álvaro Neira |
| Tema | Gestión de insumos e indumentaria |

## 2. Situación actual

- El consultorio es privado y está dirigido por la congregación Ciervas de Jesús de la Caridad. No tiene fines de lucro: cobra por las atenciones, pero ofrece atención de menor costo a quien lo necesita.
- El registro de insumos se lleva a mano, en papel, y está a cargo de una persona del staff.
- Por causa de este registro manual se han vencido insumos y se han quedado sin stock en plena atención.
- Hace un tiempo implementaron una base de datos en Excel.
- Al socio le gustó la idea de contar con un sistema de gestión de insumos.

## 3. Usuarios del sistema

- Personal administrativo, enfermeras y médicos.
- Conocimiento de tecnología promedio.
- Los equipos varían según el servicio (por ejemplo, imagenología usa computadores más potentes).

## 4. Requerimientos funcionales

| ID | Requerimiento | Objetivo A+S |
|---|---|---|
| RF-01 | Registrar el ingreso de insumos al almacenamiento general | 1 |
| RF-02 | Registrar el consumo de insumos por box, especialidad y profesional | 1 |
| RF-03 | Generar reportes de consumo en formato PDF | 2 |
| RF-04 | Alertar cuando el stock de un insumo llegue al mínimo definido | 3 |
| RF-05 | Alertar cuando un insumo esté próximo a su fecha de vencimiento | 3 |
| RF-06 | Enviar alertas al proveedor por correo o WhatsApp | 3 |

## 5. Requerimientos no funcionales

Los parámetros de esta sección son la propuesta del equipo A+S, construida a partir de lo conversado con el socio (usuarios con conocimiento promedio de tecnología y equipos de distintas capacidades). Deben ser validados con el consultorio.

| ID | Categoría | Requerimiento |
|---|---|---|
| RNF-01 | Dispositivo | El sistema se ajusta a computadores de escritorio y notebooks, con pantalla desde 1366 x 768 px. Celulares y tablets no están incluidos en esta primera versión. |
| RNF-02 | Compatibilidad | Funciona desde el navegador (Chrome, Edge o Firefox actualizados), sin instalar programas adicionales. Debe correr en equipos de capacidad básica (4 GB de RAM). |
| RNF-03 | Tipo de interfaz | Aplicación web con menú lateral fijo a la izquierda y 5 secciones: Registrar consulta, Ingreso de insumos, Salida de insumos, Alertas y Reportes. |
| RNF-04 | Botones | Máximo 3 botones por pantalla (por ejemplo: Guardar, Limpiar y Volver). El botón principal "Guardar" se destaca por tamaño y color. Alto mínimo de 44 px, con texto e ícono. |
| RNF-05 | Colores | Paleta de 5 colores: fondo blanco, azul para botones y menú, verde para confirmaciones, amarillo para insumos próximos a vencer y rojo para stock en el mínimo o vencido. Contraste de texto suficiente (mínimo 4,5:1). |
| RNF-06 | Alertas visibles | La información importante no depende solo del color: cada alerta lleva además un ícono y un texto claro (por ejemplo "Stock bajo" o "Vence en 15 días"). |
| RNF-07 | Tipografía | Letra sans-serif; texto de al menos 16 px y títulos de 24 px, para facilitar la lectura. |
| RNF-08 | Formularios | Campos obligatorios marcados con asterisco (*). Box, especialidad, profesional e insumo se eligen desde listas desplegables, sin escribirlos. Registrar una consulta toma como máximo 3 pasos. |
| RNF-09 | Lenguaje | Todo en español, con palabras de uso diario y sin tecnicismos. Los mensajes de error indican qué falló y cómo corregirlo. |
| RNF-10 | Rendimiento | Cada pantalla carga en menos de 3 segundos. Los reportes en PDF se generan en menos de 10 segundos. |
| RNF-11 | Reportes | Formato PDF, tamaño carta, con fecha de emisión y filtros por box, especialidad y profesional. |
| RNF-12 | Acceso | Ingreso con usuario y contraseña, para que solo el personal autorizado registre o modifique datos. |
| RNF-13 | Costo e infraestructura | Sin licencias de pago (base de datos en PostgreSQL). Debe poder ejecutarse en el equipo del consultorio o desde un navegador estándar. |
| RNF-14 | Capacitación | Se entrega un manual de usuario simple, con imágenes, y un taller práctico para el personal. |

## 6. Reglas de negocio y restricciones

- El consultorio opera sin fines de lucro, con recursos limitados.
- El sistema reemplaza el registro manual en papel.
- El cronograma de la Etapa 2 se mantiene sin cambios.

