# 순차회로
순차회로는 출력 신호가 그 시점의 입력에 의해서만이 아닌, 이전의 입력신호에도 의존하는 회로이다. 메모리, 레지스터, 플립플롭 등이 이에 해당한다. 그 특성 때문에, 조합회로와는 달리 **천이표(遷移表, state transition table)** 와 **타임 차트(time chart)** 를 사용하여 순차회로를 기술한다. 이 문서는 logic cell 에 포함되어 있는 **D-FF(D-type Flip Flop)** 에 대한 내용에 대해서만 기록한다.

# RS-FF
D-FF에 대해 설명하기 전에 D-FF를 구성하는 **RS-FF** 에 대하여 먼저 알아본다. RS-FF의 RS는 **Reset-Set** 의 약자로, 그 형태는 한쪽이 기울어진 시소의 형태를 생각해내면 쉽다. RS-FF의 입력은 **Reset** 과 **Set** 의 두 가지이며, 출력은 **Q** 와 **Ǭ** 의 두 가지이다(Ǭ은 Q의 정반대 값이기 때문에 실질적으로 출력은 Q 하나라고 볼 수 있다). 기울어진 시소의 한쪽에 사람이 타면 사람이 탄 쪽이 기울어지는 것처럼, RS-FF는 **Set 또는 Reset이 입력되면 시소가 그 입력 쪽으로 기울어진다** 로 해석하면 된다. 이때 Set이 한번 입력되면 Q의 값은 1이 되고, 그 값은 Reset이 입력되기 전까지 유지된다. 즉, Q = 1인 상태에서는 Set이 또다시 입력되어도 Q의 값은 변하지 않는다. 반대로 Reset이 입력되면, Q의 값은 0이 되고, 그 값은 Set이 입력되기 전까지 유지된다.

![Untitled-2 copy](https://user-images.githubusercontent.com/111409004/186793340-5c373823-3ec3-4630-ac04-cfe1d3f01e4c.png)

![RS-FF_ef2](https://user-images.githubusercontent.com/111409004/186793357-b6125c28-871c-43d1-878b-310cbf788299.png)

![Untitled2](https://user-images.githubusercontent.com/111409004/186792703-e0b8b7d1-e23b-4904-93dd-aecd0b9976d9.jpg)

*RS-FF의 천이표 ([출처](https://www.electronicshub.org/latches/))*

위의 천이표를 보면, **Qn** 은 어떤 신호가 입력되기 직전의 상태, **Qn+1** 은 어떤 신호가 입력되었을 때 그 이후의 상태를 나타낸다. 이는 Set 또는 Reset이 입력되면 시소가 그 형태를 유지한다는 의미이기도 하다. 이때 주의할 점은 **Set과 Reset 입력이 동시에 둘 다 입력될 수 없다는 것이다.** 둘 다 입력되었을 때를 "금지" 상태라고 하며, 위 천이표에서는 "-"로 나타내어져 있다.

<br/>

![1280px-RS_Flip-flop_(NOR) svg (1)](https://user-images.githubusercontent.com/111409004/187100686-7f44df6a-899a-41f6-91e7-c0be476bf6ca.png)

*RS-FF의 도식*

# D-FF
**D-FF** 혹은 **엣지 트리거(edge trigger) D-FF** 의 D는 **Delay** 의 약자이다. D-FF의 입력은 **D** 와 **CLK** 의 두 가지로, 출력은 **Q** 와 **Ǭ** 의 두 가지이다(RS-FF와 마찬가지로 출력은 실질적으로 한 개이다). CLK 입력은 일정 주기로 진동하는 클럭(Clock)의 약자를 의미한다.

![12115_f03](https://user-images.githubusercontent.com/111409004/186796306-2811820a-14df-4e87-b37e-a2315dd797b1.jpg)

*D-FF의 타임 차트 ([출처](https://jeea.or.jp/course/contents/12115/))*

위의 타임 차트에서 먼저 입력 D의 값에 주목해보자. D의 값이 1이 되면 출력 Q는 0이었다가 어느순간 1로 바뀐다. 그리고 D의 값이 0이 되면 Q는 1이었다가 어느순간 0으로 바뀐다. 그 다음엔 입력 CLK의 값에 주목해보자. CLK는 주기적으로 1이 되었다가 0이 되었다가를 반복한다. 이때, 클럭이 상승하는 시점에서 D의 값이 1일때, Q의 값이 비로소 1이 되는 것을 알 수 있으며, 클럭이 상승하는 시점에서 D의 값이 0일때, Q의 값이 0으로 변하는 것도 알 수 있다.

**엣지 트리거** 라는 용어는 클럭이 상승할 때 D의 값에 따라 출력이 변한다는 것을 의미하며, 클럭의 상승이 출력 변화를 촉발시킨다(트리거)는 뜻으로 엣지 트리거라는 이름이 붙여졌다. 이때 클럭이 상승하는 순간을 **상승 엣지(rising edge)** 라고 한다.

![D-FF](https://user-images.githubusercontent.com/111409004/186832151-adfb0efb-2a04-40f9-88f2-1038cb806e7d.PNG)

*마스터 슬레이브(master slave) 방식의 엣지 트리거 D-FF의 도식*

위 그림에서 CLK = 0, D = 1일 때 마스터 쪽이 Set 되고, 마스터 쪽의 RS-FF의 출력이 1이 된다. 다음 상승 엣지로 슬레이브 쪽으로 전파하여, 슬레이브 쪽의 RS-FF가 Set되며 Q = 1이 된다. 한편, CLK = 0, D = 0일 때는 마스터 쪽이 Reset되어, 상승엣지로 슬레이브 쪽으로 전파하여 Q = 0이 된다.
