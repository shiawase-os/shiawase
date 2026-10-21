.section .text
.extern __amd64_interrupt_dispatch

.global __amd64_load_idt
.type __amd64_load_idt, @function
__amd64_load_idt:
    lidt (%rdi)
    ret
.size __amd64_load_idt, .-__amd64_load_idt

.macro ISR_NO_ERROR vector
.global __amd64_isr_\vector
.type __amd64_isr_\vector, @function

__amd64_isr_\vector:
    pushq $0

    pushq %rbp
    pushq $\vector

    jmp __amd64_isr_common

.size __amd64_isr_\vector, .-__amd64_isr_\vector

.endm

.macro ISR_ERROR vector

.global __amd64_isr_\vector
.type __amd64_isr_\vector, @function

__amd64_isr_\vector:
    pushq %rbp

    pushq $\vector

    jmp __amd64_isr_common

.size __amd64_isr_\vector, .-__amd64_isr_\vector

.endm

// here we go

ISR_NO_ERROR 0
ISR_NO_ERROR 1
ISR_NO_ERROR 2
ISR_NO_ERROR 3
ISR_NO_ERROR 4
ISR_NO_ERROR 5
ISR_NO_ERROR 6
ISR_NO_ERROR 7
ISR_ERROR    8
ISR_NO_ERROR 9
ISR_ERROR    10
ISR_ERROR    11
ISR_ERROR    12
ISR_ERROR    13
ISR_ERROR    14
ISR_NO_ERROR 15
ISR_NO_ERROR 16
ISR_ERROR    17
ISR_NO_ERROR 18
ISR_NO_ERROR 19
ISR_NO_ERROR 20
ISR_ERROR    21
ISR_NO_ERROR 22
ISR_NO_ERROR 23
ISR_NO_ERROR 24
ISR_NO_ERROR 25
ISR_NO_ERROR 26
ISR_NO_ERROR 27
ISR_NO_ERROR 28
ISR_ERROR    29
ISR_ERROR    30
ISR_NO_ERROR 31
ISR_NO_ERROR 32
ISR_NO_ERROR 33
ISR_NO_ERROR 34
ISR_NO_ERROR 35
ISR_NO_ERROR 36
ISR_NO_ERROR 37
ISR_NO_ERROR 38
ISR_NO_ERROR 39
ISR_NO_ERROR 40
ISR_NO_ERROR 41
ISR_NO_ERROR 42
ISR_NO_ERROR 43
ISR_NO_ERROR 44
ISR_NO_ERROR 45
ISR_NO_ERROR 46
ISR_NO_ERROR 47
ISR_NO_ERROR 48
ISR_NO_ERROR 49
ISR_NO_ERROR 50
ISR_NO_ERROR 51
ISR_NO_ERROR 52
ISR_NO_ERROR 53
ISR_NO_ERROR 54
ISR_NO_ERROR 55
ISR_NO_ERROR 56
ISR_NO_ERROR 57
ISR_NO_ERROR 58
ISR_NO_ERROR 59
ISR_NO_ERROR 60
ISR_NO_ERROR 61
ISR_NO_ERROR 62
ISR_NO_ERROR 63
ISR_NO_ERROR 64
ISR_NO_ERROR 65
ISR_NO_ERROR 66
ISR_NO_ERROR 67
ISR_NO_ERROR 68
ISR_NO_ERROR 69
ISR_NO_ERROR 70
ISR_NO_ERROR 71
ISR_NO_ERROR 72
ISR_NO_ERROR 73
ISR_NO_ERROR 74
ISR_NO_ERROR 75
ISR_NO_ERROR 76
ISR_NO_ERROR 77
ISR_NO_ERROR 78
ISR_NO_ERROR 79
ISR_NO_ERROR 80
ISR_NO_ERROR 81
ISR_NO_ERROR 82
ISR_NO_ERROR 83
ISR_NO_ERROR 84
ISR_NO_ERROR 85
ISR_NO_ERROR 86
ISR_NO_ERROR 87
ISR_NO_ERROR 88
ISR_NO_ERROR 89
ISR_NO_ERROR 90
ISR_NO_ERROR 91
ISR_NO_ERROR 92
ISR_NO_ERROR 93
ISR_NO_ERROR 94
ISR_NO_ERROR 95
ISR_NO_ERROR 96
ISR_NO_ERROR 97
ISR_NO_ERROR 98
ISR_NO_ERROR 99
ISR_NO_ERROR 100
ISR_NO_ERROR 101
ISR_NO_ERROR 102
ISR_NO_ERROR 103
ISR_NO_ERROR 104
ISR_NO_ERROR 105
ISR_NO_ERROR 106
ISR_NO_ERROR 107
ISR_NO_ERROR 108
ISR_NO_ERROR 109
ISR_NO_ERROR 110
ISR_NO_ERROR 111
ISR_NO_ERROR 112
ISR_NO_ERROR 113
ISR_NO_ERROR 114
ISR_NO_ERROR 115
ISR_NO_ERROR 116
ISR_NO_ERROR 117
ISR_NO_ERROR 118
ISR_NO_ERROR 119
ISR_NO_ERROR 120
ISR_NO_ERROR 121
ISR_NO_ERROR 122
ISR_NO_ERROR 123
ISR_NO_ERROR 124
ISR_NO_ERROR 125
ISR_NO_ERROR 126
ISR_NO_ERROR 127
ISR_NO_ERROR 128
ISR_NO_ERROR 129
ISR_NO_ERROR 130
ISR_NO_ERROR 131
ISR_NO_ERROR 132
ISR_NO_ERROR 133
ISR_NO_ERROR 134
ISR_NO_ERROR 135
ISR_NO_ERROR 136
ISR_NO_ERROR 137
ISR_NO_ERROR 138
ISR_NO_ERROR 139
ISR_NO_ERROR 140
ISR_NO_ERROR 141
ISR_NO_ERROR 142
ISR_NO_ERROR 143
ISR_NO_ERROR 144
ISR_NO_ERROR 145
ISR_NO_ERROR 146
ISR_NO_ERROR 147
ISR_NO_ERROR 148
ISR_NO_ERROR 149
ISR_NO_ERROR 150
ISR_NO_ERROR 151
ISR_NO_ERROR 152
ISR_NO_ERROR 153
ISR_NO_ERROR 154
ISR_NO_ERROR 155
ISR_NO_ERROR 156
ISR_NO_ERROR 157
ISR_NO_ERROR 158
ISR_NO_ERROR 159
ISR_NO_ERROR 160
ISR_NO_ERROR 161
ISR_NO_ERROR 162
ISR_NO_ERROR 163
ISR_NO_ERROR 164
ISR_NO_ERROR 165
ISR_NO_ERROR 166
ISR_NO_ERROR 167
ISR_NO_ERROR 168
ISR_NO_ERROR 169
ISR_NO_ERROR 170
ISR_NO_ERROR 171
ISR_NO_ERROR 172
ISR_NO_ERROR 173
ISR_NO_ERROR 174
ISR_NO_ERROR 175
ISR_NO_ERROR 176
ISR_NO_ERROR 177
ISR_NO_ERROR 178
ISR_NO_ERROR 179
ISR_NO_ERROR 180
ISR_NO_ERROR 181
ISR_NO_ERROR 182
ISR_NO_ERROR 183
ISR_NO_ERROR 184
ISR_NO_ERROR 185
ISR_NO_ERROR 186
ISR_NO_ERROR 187
ISR_NO_ERROR 188
ISR_NO_ERROR 189
ISR_NO_ERROR 190
ISR_NO_ERROR 191
ISR_NO_ERROR 192
ISR_NO_ERROR 193
ISR_NO_ERROR 194
ISR_NO_ERROR 195
ISR_NO_ERROR 196
ISR_NO_ERROR 197
ISR_NO_ERROR 198
ISR_NO_ERROR 199
ISR_NO_ERROR 200
ISR_NO_ERROR 201
ISR_NO_ERROR 202
ISR_NO_ERROR 203
ISR_NO_ERROR 204
ISR_NO_ERROR 205
ISR_NO_ERROR 206
ISR_NO_ERROR 207
ISR_NO_ERROR 208
ISR_NO_ERROR 209
ISR_NO_ERROR 210
ISR_NO_ERROR 211
ISR_NO_ERROR 212
ISR_NO_ERROR 213
ISR_NO_ERROR 214
ISR_NO_ERROR 215
ISR_NO_ERROR 216
ISR_NO_ERROR 217
ISR_NO_ERROR 218
ISR_NO_ERROR 219
ISR_NO_ERROR 220
ISR_NO_ERROR 221
ISR_NO_ERROR 222
ISR_NO_ERROR 223
ISR_NO_ERROR 224
ISR_NO_ERROR 225
ISR_NO_ERROR 226
ISR_NO_ERROR 227
ISR_NO_ERROR 228
ISR_NO_ERROR 229
ISR_NO_ERROR 230
ISR_NO_ERROR 231
ISR_NO_ERROR 232
ISR_NO_ERROR 233
ISR_NO_ERROR 234
ISR_NO_ERROR 235
ISR_NO_ERROR 236
ISR_NO_ERROR 237
ISR_NO_ERROR 238
ISR_NO_ERROR 239
ISR_NO_ERROR 240
ISR_NO_ERROR 241
ISR_NO_ERROR 242
ISR_NO_ERROR 243
ISR_NO_ERROR 244
ISR_NO_ERROR 245
ISR_NO_ERROR 246
ISR_NO_ERROR 247
ISR_NO_ERROR 248
ISR_NO_ERROR 249
ISR_NO_ERROR 250
ISR_NO_ERROR 251
ISR_NO_ERROR 252
ISR_NO_ERROR 253
ISR_NO_ERROR 254
ISR_NO_ERROR 255

.global __amd64_isr_common
.type __amd64_isr_common, @function

__amd64_isr_common:
    cmpq $0x08, 0x20(%rsp)
    je 1f

    swapgs
1:
    pushq %rsi

    pushq %rdi

    pushq %r15
    pushq %r14
    pushq %r13
    pushq %r12
    pushq %r11
    pushq %r10
    pushq %r9
    pushq %r8

    pushq %rdx
    pushq %rcx
    pushq %rbx
    pushq %rax

    xorq %rax, %rax
    movw %ds, %ax
    pushq %rax

    xorq %rax, %rax
    movw %es, %ax
    pushq %rax

    xorq %rax, %rax
    movw %fs, %ax
    pushq %rax

    xorq %rax, %rax
    movw %gs, %ax
    pushq %rax

    movq %cr2, %rax
    pushq %rax

    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es

    cld

    movq 0x98(%rsp), %rdi
    movq %rsp, %rsi

    call __amd64_interrupt_dispatch

    cli

    jmp __amd64_isr_resume_from_context
.size __amd64_isr_common, .-__amd64_isr_common

.global __amd64_isr_resume_from_context
.type __amd64_isr_resume_from_context, @function

__amd64_isr_resume_from_context:
    addq $8, %rsp
    addq $8, %rsp

    popq %rax
    movw %ax, %fs

    popq %rax
    movw %ax, %es

    popq %rax
    movw %ax, %ds

    popq %rax
    popq %rbx
    popq %rcx
    popq %rdx

    popq %r8
    popq %r9
    popq %r10
    popq %r11
    popq %r12
    popq %r13
    popq %r14
    popq %r15

    popq %rdi
    popq %rsi

    addq $16, %rsp
    addq $8, %rsp

    cmpq $0x08, 0x08(%rsp)
    je 2f
    swapgs

2:
    iretq

.size __amd64_isr_resume_from_context, .-__amd64_isr_resume_from_context

.section .rodata

.global __amd64_isr_table
.type __amd64_isr_table, @object
.size __amd64_isr_table, 2048

__amd64_isr_table:
    .quad __amd64_isr_0
    .quad __amd64_isr_1
    .quad __amd64_isr_2
    .quad __amd64_isr_3
    .quad __amd64_isr_4
    .quad __amd64_isr_5
    .quad __amd64_isr_6
    .quad __amd64_isr_7
    .quad __amd64_isr_8
    .quad __amd64_isr_9
    .quad __amd64_isr_10
    .quad __amd64_isr_11
    .quad __amd64_isr_12
    .quad __amd64_isr_13
    .quad __amd64_isr_14
    .quad __amd64_isr_15
    .quad __amd64_isr_16
    .quad __amd64_isr_17
    .quad __amd64_isr_18
    .quad __amd64_isr_19
    .quad __amd64_isr_20
    .quad __amd64_isr_21
    .quad __amd64_isr_22
    .quad __amd64_isr_23
    .quad __amd64_isr_24
    .quad __amd64_isr_25
    .quad __amd64_isr_26
    .quad __amd64_isr_27
    .quad __amd64_isr_28
    .quad __amd64_isr_29
    .quad __amd64_isr_30
    .quad __amd64_isr_31
    .quad __amd64_isr_32
    .quad __amd64_isr_33
    .quad __amd64_isr_34
    .quad __amd64_isr_35
    .quad __amd64_isr_36
    .quad __amd64_isr_37
    .quad __amd64_isr_38
    .quad __amd64_isr_39
    .quad __amd64_isr_40
    .quad __amd64_isr_41
    .quad __amd64_isr_42
    .quad __amd64_isr_43
    .quad __amd64_isr_44
    .quad __amd64_isr_45
    .quad __amd64_isr_46
    .quad __amd64_isr_47
    .quad __amd64_isr_48
    .quad __amd64_isr_49
    .quad __amd64_isr_50
    .quad __amd64_isr_51
    .quad __amd64_isr_52
    .quad __amd64_isr_53
    .quad __amd64_isr_54
    .quad __amd64_isr_55
    .quad __amd64_isr_56
    .quad __amd64_isr_57
    .quad __amd64_isr_58
    .quad __amd64_isr_59
    .quad __amd64_isr_60
    .quad __amd64_isr_61
    .quad __amd64_isr_62
    .quad __amd64_isr_63
    .quad __amd64_isr_64
    .quad __amd64_isr_65
    .quad __amd64_isr_66
    .quad __amd64_isr_67
    .quad __amd64_isr_68
    .quad __amd64_isr_69
    .quad __amd64_isr_70
    .quad __amd64_isr_71
    .quad __amd64_isr_72
    .quad __amd64_isr_73
    .quad __amd64_isr_74
    .quad __amd64_isr_75
    .quad __amd64_isr_76
    .quad __amd64_isr_77
    .quad __amd64_isr_78
    .quad __amd64_isr_79
    .quad __amd64_isr_80
    .quad __amd64_isr_81
    .quad __amd64_isr_82
    .quad __amd64_isr_83
    .quad __amd64_isr_84
    .quad __amd64_isr_85
    .quad __amd64_isr_86
    .quad __amd64_isr_87
    .quad __amd64_isr_88
    .quad __amd64_isr_89
    .quad __amd64_isr_90
    .quad __amd64_isr_91
    .quad __amd64_isr_92
    .quad __amd64_isr_93
    .quad __amd64_isr_94
    .quad __amd64_isr_95
    .quad __amd64_isr_96
    .quad __amd64_isr_97
    .quad __amd64_isr_98
    .quad __amd64_isr_99
    .quad __amd64_isr_100
    .quad __amd64_isr_101
    .quad __amd64_isr_102
    .quad __amd64_isr_103
    .quad __amd64_isr_104
    .quad __amd64_isr_105
    .quad __amd64_isr_106
    .quad __amd64_isr_107
    .quad __amd64_isr_108
    .quad __amd64_isr_109
    .quad __amd64_isr_110
    .quad __amd64_isr_111
    .quad __amd64_isr_112
    .quad __amd64_isr_113
    .quad __amd64_isr_114
    .quad __amd64_isr_115
    .quad __amd64_isr_116
    .quad __amd64_isr_117
    .quad __amd64_isr_118
    .quad __amd64_isr_119
    .quad __amd64_isr_120
    .quad __amd64_isr_121
    .quad __amd64_isr_122
    .quad __amd64_isr_123
    .quad __amd64_isr_124
    .quad __amd64_isr_125
    .quad __amd64_isr_126
    .quad __amd64_isr_127
    .quad __amd64_isr_128
    .quad __amd64_isr_129
    .quad __amd64_isr_130
    .quad __amd64_isr_131
    .quad __amd64_isr_132
    .quad __amd64_isr_133
    .quad __amd64_isr_134
    .quad __amd64_isr_135
    .quad __amd64_isr_136
    .quad __amd64_isr_137
    .quad __amd64_isr_138
    .quad __amd64_isr_139
    .quad __amd64_isr_140
    .quad __amd64_isr_141
    .quad __amd64_isr_142
    .quad __amd64_isr_143
    .quad __amd64_isr_144
    .quad __amd64_isr_145
    .quad __amd64_isr_146
    .quad __amd64_isr_147
    .quad __amd64_isr_148
    .quad __amd64_isr_149
    .quad __amd64_isr_150
    .quad __amd64_isr_151
    .quad __amd64_isr_152
    .quad __amd64_isr_153
    .quad __amd64_isr_154
    .quad __amd64_isr_155
    .quad __amd64_isr_156
    .quad __amd64_isr_157
    .quad __amd64_isr_158
    .quad __amd64_isr_159
    .quad __amd64_isr_160
    .quad __amd64_isr_161
    .quad __amd64_isr_162
    .quad __amd64_isr_163
    .quad __amd64_isr_164
    .quad __amd64_isr_165
    .quad __amd64_isr_166
    .quad __amd64_isr_167
    .quad __amd64_isr_168
    .quad __amd64_isr_169
    .quad __amd64_isr_170
    .quad __amd64_isr_171
    .quad __amd64_isr_172
    .quad __amd64_isr_173
    .quad __amd64_isr_174
    .quad __amd64_isr_175
    .quad __amd64_isr_176
    .quad __amd64_isr_177
    .quad __amd64_isr_178
    .quad __amd64_isr_179
    .quad __amd64_isr_180
    .quad __amd64_isr_181
    .quad __amd64_isr_182
    .quad __amd64_isr_183
    .quad __amd64_isr_184
    .quad __amd64_isr_185
    .quad __amd64_isr_186
    .quad __amd64_isr_187
    .quad __amd64_isr_188
    .quad __amd64_isr_189
    .quad __amd64_isr_190
    .quad __amd64_isr_191
    .quad __amd64_isr_192
    .quad __amd64_isr_193
    .quad __amd64_isr_194
    .quad __amd64_isr_195
    .quad __amd64_isr_196
    .quad __amd64_isr_197
    .quad __amd64_isr_198
    .quad __amd64_isr_199
    .quad __amd64_isr_200
    .quad __amd64_isr_201
    .quad __amd64_isr_202
    .quad __amd64_isr_203
    .quad __amd64_isr_204
    .quad __amd64_isr_205
    .quad __amd64_isr_206
    .quad __amd64_isr_207
    .quad __amd64_isr_208
    .quad __amd64_isr_209
    .quad __amd64_isr_210
    .quad __amd64_isr_211
    .quad __amd64_isr_212
    .quad __amd64_isr_213
    .quad __amd64_isr_214
    .quad __amd64_isr_215
    .quad __amd64_isr_216
    .quad __amd64_isr_217
    .quad __amd64_isr_218
    .quad __amd64_isr_219
    .quad __amd64_isr_220
    .quad __amd64_isr_221
    .quad __amd64_isr_222
    .quad __amd64_isr_223
    .quad __amd64_isr_224
    .quad __amd64_isr_225
    .quad __amd64_isr_226
    .quad __amd64_isr_227
    .quad __amd64_isr_228
    .quad __amd64_isr_229
    .quad __amd64_isr_230
    .quad __amd64_isr_231
    .quad __amd64_isr_232
    .quad __amd64_isr_233
    .quad __amd64_isr_234
    .quad __amd64_isr_235
    .quad __amd64_isr_236
    .quad __amd64_isr_237
    .quad __amd64_isr_238
    .quad __amd64_isr_239
    .quad __amd64_isr_240
    .quad __amd64_isr_241
    .quad __amd64_isr_242
    .quad __amd64_isr_243
    .quad __amd64_isr_244
    .quad __amd64_isr_245
    .quad __amd64_isr_246
    .quad __amd64_isr_247
    .quad __amd64_isr_248
    .quad __amd64_isr_249
    .quad __amd64_isr_250
    .quad __amd64_isr_251
    .quad __amd64_isr_252
    .quad __amd64_isr_253
    .quad __amd64_isr_254
    .quad __amd64_isr_255
