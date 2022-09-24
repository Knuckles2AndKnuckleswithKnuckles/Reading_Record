# 소개
챕터 3에서는 트라이 스테이트 버퍼에 이어 VHDL의 주요 문법들에 대해 다룬다. 문서가 너무 길어지기 때문에 분리하여 서술한다.

# 조건 신호 할당문(Conditional signal assignment statement)
조건 신호 할당문은 이미 std_logic의 Z값을 합성하기 위한 예시로 다룬 바 있다. 간단한 조건 신호 할당문의 템플릿은 다음과 같다.

``` vhdl
  signal_name <= value_1 when boolean_1 else
                 value_2 when boolean_2 else
                 ...
                 value_n;
```

여타 프로그래밍 언어와 마찬가지로, boolean 식이 참이 될 때까지 순차적으로 평가되며, 해당하는 값이 신호에 할당된다. 마지막의 **value_n** 은 모든 boolean 식이 false로 평가되면 신호에 할당된다. 조건은 boolean 식이기만 하면 되기에, 관계 연산자 또한 사용할 수 있다. (예를 들어 when m > n ... 과 같이 쓰면 이 또한 boolean 식으로써 평가될 수 있다.)

조건 신호 할당문을 구체적으로 생각해보자면, 위 예시에서 *signal_name* 과 *value* 신호를 연결하는 **루팅(routing)** 은 **멀티플렉서의 배열(sequence of multiplexers)** 을 통해 이루어진다. 

![2022-09-16 10 24 10](https://user-images.githubusercontent.com/111409004/190536918-c906b298-ebb7-4d28-9936-cb8c5b589000.png)

*2 to 1 멀티플렉서의 도식*

2 to 1 멀티플렉서는 **i0** , **i1** , **opt** 의 세 가지 입력과 **output** 의 한 가지 출력을 가진다. opt가 논리적 0일 때 output은 i0에 루팅되고, opt가 1일 때 output은 i1에 루팅된다.

주의할 점은 모든 boolean 식과 value 식은 병행으로 평가된다. boolean 식의 값에 따라 멀티플렉서의 opt 값을 설정하고 원하는 value 값을 output에 배선하며, when-else 구문이 많아질수록 더 긴 전파시간을 낳게된다.

# 선택 신호 할당문(Selected signal assignment statement)
간단한 선택 신호 할당문의 템플릿은 다음과 같다.

``` vhdl
  with sel select
    sig <= value_1 when choice_1,
           value_2 when choice_2,
           value_3 when choice_3,
           ...
           value_n when others;
```

선택 신호 할당문은 여타 프로그래밍 언어의 *case* 와 어느정도 비슷하다. 이것은 어떤 식을 **sel** 신호의 값에 따라 신호에 할당한다. *choice(i.e. choice_n)* 는 반드시 유효한 값이거나 sel 의 유효한 값들의 집합(a set of valid value of sel)이어야 하며, choice 들은 반드시 상호 배타적(mutually exclusive)이어야 한다. 바꿔 말하자면, 가능한 모든 sel 의 값들은 반드시 단 하나의 choice만으로 다루어져야 한다. 마지막의 **others** 는 sel 이 choice와 일치하지 않을 때 마지막으로 할당된다. sel 신호는 일반적으로 std_logic_vector 타입을 갖기 때문에, others 구문은 합성 불가능한 값들('X'나 'U' 등)을 다루기 위해 항상 필요하다.

# Process





