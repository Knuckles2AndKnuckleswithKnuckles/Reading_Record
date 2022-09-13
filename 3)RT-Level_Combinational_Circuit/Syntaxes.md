# 소개
챕터 3에서는 트라이 스테이트 버퍼에 이어 VHDL의 주요 문법들에 대해 다룬다. 문서가 너무 길어지기 때문에 분리하여 서술한다.

# 조건 신호 할당문(Conditional signal assignment statement)
조건 신호 할당문은 이미 std_logic의 Z값을 합성하기 위한 예시로 다룬 바 있다. 간단한 조건 신호 할당문의 예시는 다음과 같다.

``` vhdl
  signal_name <= value_1 when boolean_1 else
                 value_2 when boolean_2 else
                 ...
                 value_n;
```

다른 프로그래밍 언어와 마찬가지로, boolean 식이 참이 될 때까지 순차적으로 평가되며, 해당하는 값이 신호에 할당된다. 마지막의 **value_n** 은 모든 boolean 식이 false로 평가되면 신호에 할당된다.
