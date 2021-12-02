## 00. MatrixMultiplication (OpenMP)

<img src="https://github.com/PARCO-LAB/Advanced-Computer-Architectures/blob/main/figures/l6_00.jpg" width="500" height=auto> 

### Performance reference table (N = 1024):

CPU time   | GPU time | Speedup  | Device             | Mode  |Author
-----------| -------- | -------- | ------------------ | ----  |------
57194 ms   | 25 ms    | 2198x     | Nvidia Jetson TX2  | Shared Mem | -
52100 ms   | 84 ms    | 614x     | Nvidia Jetson TX2  | No Shared | -
8174 ms   |  -    | 3x     | Nvidia Jetson TX2  | OpenMP (-O3) | -
9793 ms   |  -    | 3x     | Nvidia Jetson TX2  | OpenMP (-O0) | -
