# Cookie Validator

## Solution

- Start by going to the IP address given by the challenge

- Press F12 or go into Inspect Mode and click on the Network tab and refresh the page. Make sure to have selected All.

- You should see a Web Assembly (.wasm) file. Download it and run the following command to decompile it (If you don't have wasm2wat install it)

```bash
wasm2wat cookie_validator.wasm -o cookie_validator.wat 
```

- ```cat``` the contents of the output file

- You should see some fake flags and the segments of the real flag. Reconstruct them to get the flag

```
SLEIGH{w4sm_c00k13s_4r3_d3l1c10us}
```
