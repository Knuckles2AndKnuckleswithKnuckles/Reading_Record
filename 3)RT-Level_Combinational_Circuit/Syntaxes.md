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

선택 신호 할당문은 여타 프로그래밍 언어의 *case* 와 어느정도 비슷하다. 이것은 어떤 식을 **sel** 신호의 값에 따라 신호에 할당한다. *choice(i.e. choice_n)* 는 반드시 유효한 값이거나 sel 의 유효한 값들의 집합(a set of valid value of sel)이어야 하며, choice 들은 반드시 상호 배타적(mutually exclusive)이어야 한다. 바꿔 말하자면, 가능한 모든 sel 의 값들은 반드시 단 하나의 choice만으로 다루어져야 한다. 마지막의 **others** 는 sel 이 choice와 일치하지 않을 때 마지막으로 할당된다. 

sel 신호는 일반적으로 std_logic_vector 타입을 갖기 때문에, others 구문은 합성 불가능한 값들('X'나 'U' 등)을 다루기 위해 항상 필요하다.

# Process
시스템 설계를 용이하게 하기 위해, VHDL은 여러 **순차문(sequential statement)** 을 포함하고 있다. 병렬로 처리하는 일반적인 회로와는 달리, 순차문은 *process* 문으로 둘러싸여 있다.

순차문은 다양한 구조들을 포함하고 있으나, 이 중의 대다수는 명확한 하드웨어 대응책(hardware counterpart)들을 가지고 있지 않다. 스파게티 코드된 process 문은 빈번하게 불필요하고 복잡한 시행을 야기하거나 합성되지 않을 수 있다. 합성을 위해, 이 책에서는 process 문을 두가지 목적을 위해 사용을 제한한다.

+ *if* 와 *case* 문의 배선 구조의 서술
+ 메모리 요소를 위한 구조 템플릿 (챕터 4에서 다룰 예정이다.)

간단한 process 문의 템플릿은 다음과 같다.

```vhdl
  process (sensitivity_list)
  begin
    sequential statement;
    sequential statement;
    ...
  end process;
```

**sensitivity_list** 는 순차문으로 반응하는 신호들의 목록이다. 순차문으로 인해 변화가 생기는 신호가 있다면 목록에 포함되어야 하며, 조합 회로는 모든 입력 신호를 목록에 포함시켜야 한다.

## 순차 신호 할당문(Sequential signal assignment statement)
가장 간단한 순차문으로는 **순차 신호 할당문** 이 있다. 간단한 순차 신호 할당문의 템플릿은 다음과 같다.

```vhdl
  process (sensitivity_list)
  begin
  signal <= value_expresion;
  end process;
```

process 문으로 둘러싸여 있다는 점만 제외하면 일반적인 병행처리문에서의 신호 할당과 별다른 차이가 없어보일 수 있으나, 그 의미는 다르다. 다음 예시를 살펴보자.

``` vhdl
  process (a, b)
  begin
    c <= a and b;
    c <= a or b;
  end process;
```

이는 다음과 같다.

``` vhdl
  process (a, b)
  begin
    c <= a or b;
  end process;
```

반면, 이를 병행처리문으로 쓰면,

``` vhdl
  -- *not within a process*
  c <= a and b;
  c <= a or b;
```

이 코드는 출력이 서로 연결되어 있는 **and** 와 **or** 게이트를 암시(infer)하고 있으며 이는 설계 오류에 해당한다. 

위와 같이 process 문에 신호를 여러번 할당하는 의미는 미묘하고 가끔 오류를 일으키기 쉬울 수 있다. 이 책에서는 의도되지 않은 메모리를 방지하기 위한 목적으로만 순차문에서 신호를 여러번 할당하기로 한다. 

