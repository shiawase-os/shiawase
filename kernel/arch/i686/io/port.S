// i686 PMIO (Port Mapped I/O) functions

.section .text
.global outb
.type outb, @function

// void outb(uint16_t port, uint8_t data)
// port -> 4(%esp)
// data -> 8(%esp)

outb:
    movw 4(%esp), %dx
    movb 8(%esp), %al

    outb %al, %dx
    ret

.size outb, . - outb
