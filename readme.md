# CRC生成器
## 概述
CRC生成器是一个命令行应用程序，用于生成任意数据宽度（1到1024）和多项式宽度（1到1024）的Verilog或VHDL代码。代码使用C编写，支持跨平台运行。

## 参数
- language：指定生成的语言，可以是verilog或vhdl。
- data_width：数据总线宽度，范围为1到1024。
- poly_width：多项式宽度，范围为1到1024。
- poly_string：描述CRC多项式的字符串（十六进制表示）。

## 示例
假设我们要生成一个USB CRC5校验码模块，其多项式为x^5 + x^2 + 1，可以表示为十六进制05：

```sh
crc-gen verilog 8 5 05
```

## 版权声明
原作品版权所有 © 2009 OutputLogic.com

原作者：[Evgeni Stavinov](https://opencores.org/projects/parallelcrcgen)，[OutputLogic.com](https://OutputLogic.com)

原许可协议：MIT许可证

---
修改版本版权 © 2024 John_Tito

修改者：[John_Tito](https://github.com/John-Tito)

许可协议：MIT许可证
