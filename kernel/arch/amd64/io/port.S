// AMD64 PMIO (Port Mapped I/O) functions
.section .text
.global outb
.type outb, @function

// void outb(uint16_t port, uint8_t data)
// port -> rdi (%di)
// data -> rsi (%sil)
outb:
    movw %di, %dx
    movb %sil, %al

    outb %al, %dx
    ret

.size outb, . - outb
