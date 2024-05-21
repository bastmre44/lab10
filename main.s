.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

// Direcciones base y desplazamientos
.equ RCC_BASE, 0x40023800               // Dirección base del RCC
.equ AHB1ENR_OFFSET, 0x30               // Desplazamiento para habilitar AHB1
.equ RCC_AHB1ENR, (RCC_BASE + AHB1ENR_OFFSET) // Dirección del registro RCC_AHB1ENR
.equ GPIOA_EN, (1 << 0)                 // Bit para habilitar el puerto GPIOA

.equ GPIOA_BASE, 0x40020000             // Dirección base del puerto GPIOA
.equ GPIOA_MODER_OFFSET, 0x00           // Desplazamiento para el registro MODER de GPIOA
.equ GPIOA_PUPDR_OFFSET, 0x0C           // Desplazamiento para el registro PUPDR de GPIOA
.equ GPIOA_ODR_OFFSET, 0x14             // Desplazamiento para el registro ODR de GPIOA

.equ GPIOA_MODER, (GPIOA_BASE + GPIOA_MODER_OFFSET) // Dirección del registro MODER de GPIOA
.equ GPIOA_PUPDR, (GPIOA_BASE + GPIOA_PUPDR_OFFSET) // Dirección del registro PUPDR de GPIOA
.equ GPIOA_ODR, (GPIOA_BASE + GPIOA_ODR_OFFSET)     // Dirección del registro ODR de GPIOA

.equ MODER_PA0_OUT, (0x1 << 0)          // Configuración de PA0 como salida
.equ PUPDR_PA0_NOPULL, (0x0 << 0)       // Configuración de PA0 sin pull-up/pull-down
.equ LED_ON, (1 << 0)                   // Bit para encender el LED en PA0
.equ LED_OFF, ~(1 << 0)                 // Bit para apagar el LED en PA0

.section .text
.globl __main

__main:
    // Habilitar el reloj para GPIOA
    LDR R0, =RCC_AHB1ENR                 // Cargar la dirección de RCC_AHB1ENR en R0
    LDR R1, [R0]                         // Leer el valor actual de RCC_AHB1ENR en R1
    ORR R1, #GPIOA_EN                    // Habilitar el reloj para GPIOA (bit 0)
    STR R1, [R0]                         // Escribir el valor modificado de vuelta a RCC_AHB1ENR

    // Configurar PA0 como salida
    LDR R0, =GPIOA_MODER                 // Cargar la dirección de GPIOA_MODER en R0
    LDR R1, [R0]                         // Leer el valor actual de GPIOA_MODER en R1
    BIC R1, #(0x3 << 0)                  // Limpiar los bits 1:0 para PA0
    ORR R1, #(MODER_PA0_OUT)             // Configurar los bits 1:0 como 01 para PA0 (salida)
    STR R1, [R0]                         // Escribir el valor modificado de vuelta a GPIOA_MODER

    // Configurar PA0 sin pull-up/pull-down
    LDR R0, =GPIOA_PUPDR                 // Cargar la dirección de GPIOA_PUPDR en R0
    LDR R1, [R0]                         // Leer el valor actual de GPIOA_PUPDR en R1
    BIC R1, #(0x3 << 0)                  // Limpiar los bits 1:0 para PA0
    STR R1, [R0]                         // Escribir el valor modificado de vuelta a GPIOA_PUPDR

    // Encender el LED en PA0
    LDR R0, =GPIOA_ODR                   // Cargar la dirección de GPIOA_ODR en R0
    LDR R1, [R0]                         // Leer el valor actual de GPIOA_ODR en R1
    ORR R1, #LED_ON                      // Establecer el bit 0 para encender el LED en PA0
    STR R1, [R0]                         // Escribir el valor modificado de vuelta a GPIOA_ODR

    // Llamar a la rutina de retardo
    BL delay

    // Apagar el LED en PA0
    LDR R0, =GPIOA_ODR                   // Cargar la dirección de GPIOA_ODR en R0
    LDR R1, [R0]                         // Leer el valor actual de GPIOA_ODR en R1
    BIC R1, #LED_ON                      // Limpiar el bit 0 para apagar el LED en PA0
    STR R1, [R0]                         // Escribir el valor modificado de vuelta a GPIOA_ODR

    // Llamar a la rutina de retardo
    BL delay

    // Bucle infinito
    B __main                             // Volver al inicio del programa

// Rutina de retardo
delay:
    PUSH {R0, R1, R2}                    // Guardar los registros R0, R1, R2 en la pila
    LDR R2, =3000000                     // Cargar el valor del contador de retardo en R2
delay_loop:
    SUBS R2, R2, #1                      // Decrementar R2
    BNE delay_loop                       // Si R2 no es cero, saltar a delay_loop
    POP {R0, R1, R2}                     // Restaurar los registros R0, R1, R2 desde la pila
    BX LR                                // Volver de la subrutina

.section .data

    .align
    .end
