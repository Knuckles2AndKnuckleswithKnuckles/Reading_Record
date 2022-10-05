# 소개
챕터 3에서는 트라이 스테이트 버퍼에 이어 VHDL의 주요 문법들에 대해 다룬다. 문서가 너무 길어지기 때문에 분리하여 서술한다.

# 병행 할당문(Cocurrent assignment statement)을 통한 회로의 배선
다음의 조건 신호 할당문과 선택 신호 할당문은 **병행 할당문** 에 해당된다. 이들은 바로 밑에서 다루겠지만 여타 프로그래밍 언어의 *if* 와 *case* 문과 비슷해보이나, 순차적으로 실행되는 프로그래밍 언어와는 달리 병행처리되어 합성 과정에서 멀티플렉서 등으로 네트워크를 이룬다. (의역, 원문: these statements are mapped to a routing network during synthesis.)

## 조건 신호 할당문(Conditional signal assignment statement)
조건 신호 할당문은 이미 std_logic의 Z값을 합성하기 위한 예시로 다룬 바 있다. 간단한 조건 신호 할당문의 템플릿은 다음과 같다.

``` vhdl
  signal_name <= value_1 when boolean_1 else
                 value_2 when boolean_2 else
                 ...
                 value_n;
```

여타 프로그래밍 언어와 마찬가지로, boolean 식이 참이 될 때까지 연달아(successively) 평가되며, 해당하는 값이 신호에 할당된다. 마지막의 **value_n** 은 모든 boolean 식이 false로 평가되면 신호에 할당된다. 조건은 boolean 식이기만 하면 되기에, 관계 연산자 또한 사용할 수 있다. (예를 들어 when m > n ... 과 같이 쓰면 이 또한 boolean 식으로써 평가될 수 있다.)

조건 신호 할당문을 구체적으로 생각해보자면, 위 예시에서 *signal_name* 과 *value* 신호를 연결하는 **루팅(routing)** 은 **멀티플렉서의 배열(sequence of multiplexers)** 을 통해 이루어진다. 

![2022-09-16 10 24 10](https://user-images.githubusercontent.com/111409004/190536918-c906b298-ebb7-4d28-9936-cb8c5b589000.png)

*2 to 1 멀티플렉서의 도식*

2 to 1 멀티플렉서는 **i0** , **i1** , **opt** 의 세 가지 입력과 **output** 의 한 가지 출력을 가진다. opt가 논리적 0일 때 output은 i0에 루팅되고, opt가 1일 때 output은 i1에 루팅된다.

주의할 점은 모든 boolean 식과 value 식은 병행으로 평가된다. boolean 식의 값에 따라 멀티플렉서의 opt 값을 설정하고 원하는 value 값을 output에 배선하며, when-else 구문이 많아질수록 더 긴 전파지연을 낳게된다.

## 선택 신호 할당문(Selected signal assignment statement)
간단한 선택 신호 할당문의 템플릿은 다음과 같다.

``` vhdl
  with sel select
    sig <= value_1 when choice_1,
           value_2 when choice_2,
           value_3 when choice_3,
           ...
           value_n when others;
```

선택 신호 할당문은 여타 프로그래밍 언어의 *case* 와 어느정도 비슷하다. 이것은 어떤 식을 **sel** 신호의 값에 따라 신호에 할당한다. *choice(i.e. choice_n)* 는 반드시 유효한 값이거나 sel 의 유효한 값들의 집합(a set of valid value of sel)이어야 하며, choice 들은 반드시 상호 배타적(mutually exclusive)이어야 한다. 바꿔 말하자면, 모든 sel 이 가능한 값들은 반드시 단 하나의 choice 만으로 다루어져야 한다. 마지막의 **others** 는 sel 이 choice와 일치하지 않을 때 마지막으로 할당된다. 

sel 신호는 일반적으로 std_logic_vector 타입을 갖기 때문에, others 구문은 합성 불가능한 값들('X'나 'U' 등)을 다루기 위해 항상 필요하다.

# Process
시스템 설계를 용이하게 하기 위해, VHDL은 여러 **순차문(sequential statement)** 을 포함하고 있다. 병렬로 처리하는 일반적인 회로와는 달리, 순차문은 *process* 문으로 둘러싸여 있다.

순차문은 다양한 구조들을 포함하고 있으나, 이 중의 대다수는 명확한 하드웨어 대응책(hardware counterpart)들을 가지고 있지 않다. 스파게티 코드된 process 문은 빈번하게 불필요하고 복잡한 시행을 야기하거나 합성되지 않을 수 있다. 합성을 위해, 이 책에서는 process 문을 두가지 목적을 위해 사용을 제한한다.

+ *if* 와 *case* 문의 배선 구조의 서술 (책에서는 합성과정에서 배선 구조의 우선순위를 언급하나, 내용이 얕고 인터넷에도 구체적인 내용을 찾지 못해 여기선 다루지 않는다.)
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

# IF 문과 CASE 문을 통한 회로의 배선
이들은 바로 밑에서 다루겠지만 병행 할당문과는 달리 **순차적으로 평가** 된다.

## if 문(if statement)
간단한 if 문의 템플릿은 다음과 같다.

```vhdl
  if boolean_1 then
    sequential_statements;
  
  elseif boolean_2 then
    sequential_statements;
  
  elseif boolean_3 then
    sequential_statements;
    
  ...
  
  else
    sequential_statements;
  end if;
```

if 문은 하나의 *if* 분기점을 갖고, 하나 혹은 여러개의 임의의 *elseif* 분기점을 가지며, 하나의 임의의 *else* 분기점을 갖는다. boolean 식은 *true* 혹은 *else* 분기점에 도달할 때까지 순차적으로 평가되며, 그에 상응하는 분기점이 실행된다.

if 문은 조건 신호 할당문과 어느정도 유사해 보인다. 이들은 if 문이 단 하나의 순차적인 신호 할당문을 포함했을 때 서로 같은 역할을 한다. 예를 들어,

``` vhdl
  r <= a + b + c when m = n else
       a - b     when m > 0 else
       c + 1;
```

위의 조건 신호 할당문은 다음과 같이 쓸 수도 있다.

``` vhdl
  process (a, b, c, m, n)
  begin
    if m = n then
      r <= a + b + c;
    
    elseif m > 0 then
      r <= a - b;
    
    else
      r <= c + 1;
    end if;
  end process;
```

## case 문(case statement)
간단한 case 문의 템플릿은 다음과 같다.

``` vhdl
  case sel is
    when choice_1 =>
      sequential statements;
  
    when choice_2 =>
      sequential statements;
    ...  
  
    when others =>
      sequential statements;
  end case;
```

case 문은 **sel** 신호를 사용하여 순차문의 집합을 선택한다. 선택 신호 할당문과 같이, *choice(i.e. choice_n)* 는 반드시 유효한 값이거나 sel 의 유효한 값들의 집합이어야 하며, choice 들은 반드시 상호 배타적이어야 한다. 마지막의 **others** 는 사용되지 않은 값을 보완하기 위해 사용된다.

case 문과 선택 신호 할당문은 어느정도 비슷하다. 이들은 case 문이 단 하나의 순차 신호 할당문을 포함하고 있을 때 서로 같은 역할을 한다. 예를 들어,

``` vhdl
  with sel select
    r <= a + b + c when "00",
         a - b     when "10",
         c + 1     when others;
```

위의 선택 신호 할당문은 다음과 같이 쓸 수 있다.

``` vhdl
  process (a, b, c, sel)
  begin
    case sel is
      when "00" =>
        r <= a + b + c;
      
      when "10" =>
        r <= a - b;
      
      when others =>
        r <= c + 1;
    end case;
  end process;
```

## 병행문과의 비교(Comparison to concurrent statements)
앞서 다루었던 순차문이 하나인 if 와 case 문은 각각 조건 신호 할당문과 선택 신호 할당문과 같은 역할을 한다. 그러나 if 와 case 문은 모든 숫자와 모든 타입의 순차문을 모든 분기점에서 허용하므로, 병행 할당문과 비교해서 더 유연하고 다재다능하다.

이는 다음 예시를 통해 예증할 수 있다. 먼저, 두 가지의 입력 신호를 정렬하고 큰 값과 작은 값을 각각 **large** 와 **small** 출력에 배선하는 회로를 생각해본다. 이는 조건 신호 할당문을 두 개 사용하여 다음과 같이 나타낼 수 있다.

``` vhdl
  large <= a when a > b else
           b;
  small <= b when a > b else
           a;
```

이와 같은 기능을 하는 코드를 if 문으로 작성할 수도 있다.

``` vhdl
  process (a, b)
  begin
    if a > b then
      large <= a;
      small <= b;
    
    else
      large <= b;
      small <= a;
    end if;
  end process;
```

조건 신호 할당문은 비교 연산자를 2번 사용한 것에 반해, if 문은 비교 연산자를 1번 사용하여, 합성에서 비교기의 사용에서 차이가 나타난다.

두 번째로, 세 입력 신호 중 가장 큰 값을 출력에 배선하는 회로를 생각해본다. 이는 2개의 중첩된 if 문을 사용하여 명확하게 기술할 수 있다.

``` vhdl
  process (a, b, c)
  begin
    if (a > b) then
      if (a > c) then
        max <= a;
      else
        max <= c;
      end if;
    
    else
      if (b > c) then
        max <= b;
      else
        max <= c;
      end if;
    end if;
  end process;
```

이를 조건 신호 할당문으로 쓰면 다음과 같다.

``` vhdl
  max <= a when ((a > b) and (a > c)) else
         c when (a > b) else
         b when (b > c) else
         c;
```

if 문과 같이 중첩하여 쓸 수 없기 때문에, 조건 신호 할당문은 덜 직관적으로 보인다. 만약 병행 할당문이 반드시 사용되어야 한다면, 다음과 같이 3개의 조건 신호 할당문을 사용하여 회로를 기술할 수도 있다.

``` vhdl
  signal ac_max, bc_max : std_logic;
  ...
  
  ac_max <= a when (a > c) else
            c;
  bc_max <= b when (b > c) else
            c;
  
  max <= ac_max when (a > b) else
         bc_max;
```

## 의도하지 않은 메모리

비록 process 가 유연하다고는 하지만, 코드의 사소한 오류로 인해 부정확한 시행을 일으킬 수 있다. 이러한 문제를 가진 하나의 흔한 예로는 조합회로에서 의도한 메모리를 포함시킬 때이다. VHDL 표준에서는 process 안에서 할당되지 않을 경우, 신호는 이전의 값을 유지하도록 명시되어 있다. 합성 과정에서 이것은 닫힌 피드백 루프를 통한 내부 상태(an internal state via a closed feedback loop)나, 래치와 같은 메모리 요소를 도출하게 된다. 이러한 현상을 방지하기 위해, 조합회로를 설계할 때 다음과 같은 규칙을 준수해야 한다.

+ sensitivity list 에 모든 입력 신호를 기입한다.
+ if 문을 사용할 때는 else 분기점을 추가한다.
+ 모든 분기점의 모든 신호에 값을 할당한다.

다음 예시 코드는 **~보다 크다(gt, greater-than)** 와 **서로 같다(eq, equal-to)** 출력 신호를 만든다.

``` vhdl
  process (a) -- 'b' missing from sensitivity list
  begin
    if (a > b) then
      gt <= '1'; -- eq is not assigned in this branch
    
    elseif (a = b) then
      eq <= '1'; -- gt is not assigned in this branch
      
    end if; -- else branch is omitted
  end process
```

이는 비록 문법은 맞으나, 위의 3가지 규칙을 모두 위반했다. 예를 들어, **gt** 는 "a > b" 식이 거짓이 될 때 이전의 값을 유지할 것이고, 이에 따라 래치가 생성될 것이다. 위의 규칙을 준수한 코드는 다음과 같다.

``` vhdl
  process (a, b)
  begin
    if (a > b) then
      gt <= '1';
      eq <= '0';
    
    elseif (a = b) then
      gt <= '0';
      eq <= '1';
      
    else
      gt <= '0';
      eq <= '0';
      
    end if;
  end process;
```

상술한 대로 process 문에서 순차 신호 할당문이 여러번 사용되면 오류를 불러일으킬 수 있기 때문에, 이 문제를 해결하기 위해선 다음과 같이 값을 할당할 수 있다.

``` vhdl
  process (a, b)
  begin
    gt <= '0';
    eq <= '0';
    
    if (a > b) then
      gt <= '1';
    
    elseif (a = b) then
      eq <= '1';
    
    end if;
  end process;
```

gt 와 eq 신호를 처음부터 '0'으로 추정하여 if 문 내에서 할당되지 않았을 경우를 대비한다.(때문에 else 문을 사용하여 신호를 다시 할당하는 번거로움이 줄어들었다.) process 문 내에서 신호를 여러번 할당하는 행동은 "모든 분기점에서 모든 신호를 할당한다"는 규칙을 만족시켜야 할 때에만 차선책으로 고려하는 습관을 들이자.

# 정수(定数)와 Generics

## 정수(定数, Constant)
HDL 코드는 식과 배열에서 정수를 빈번하게 사용한다. 좋은 설계습관 중의 하나는 바로 어렵고 이해하기 힘든 리터럴을 상징적인 정수로 바꾸는 것이다.(리터럴이란 "문자 그대로" 라는 뜻으로, 일반적인 프로그래밍 언어에서는 '1', 'A', "This is literal" 과 같이 숫자, 문자, 문자열 등을 포함한다.) 이는 코드를 명확하게 하고, 후에 유지보수 및 수정을 용이하게 해준다. 정수의 정의는 architecture 의 선언부에 포함되며, 간단한 템플릿은 다음과 같다.

``` vhdl
  constant const_name : data_type := value_expression;
```

예시로, 정수를 2개 선언하는 코드는 다음과 같다.

``` vhdl
  constant DATA_BIT : integer := 8;
  constant DATA_RANGE : integer := (2**DATA_BIT) - 1;
```

정수 식은 전처리(preprocessing) 과정 중에 평가되고, 따라서 물리적인 회로를 필요로 하지 않는다. 이후로 이 책에서는 정수를 대문자로 사용한다.

다음 예시는 **Carry-Out** 을 포함한 4bit 가산기를 설계한 것으로, 이는 입력을 1bit 확장하고 일반적인 덧셈을 수행하는 것으로 구현할 수 있다. 덧셈의 결과의 MSB를 Carry-Out 으로 한다.

``` vhdl
-- Adder using a hard literal

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_w_carry is
  port(
    a, b : in std_logic_vector(3 downto 0);
    co : out std_logic;
    sum : out std_logic_vector(3 downto 0)
  );
end add_w_carry;

architecture hard_arch of add_w_carry is
  signal a_ext, b_ext, sum_ext : unsigned(4 downto 0);

begin
  a_ext <= unsigned('0' & a);
  b_ext <= unsigned('0' & b);
  sum_ext <= a_ext + b_ext;
  sum <= std_logic_vector(sum_ext(3 downto 0));
  co <= sum_ext(4);
end hard_arch;
```

위의 코드는 std_logic_vector 배열을 리터럴로 할당, 참조하게끔 쓴 것으로, 이후 이 코드를 8bit 가산기로 수정하는 작업을 하게 되면 리터럴을 전부 수정해야 하는 번거로움이 생기게 된다. 이는 코드가 복잡해질수록 더 많은 리터럴을 사용해야 하므로, 읽기 힘들어지는 것은 물론 오류를 불러일으키기도 쉬워지게 된다. 이렇게 리터럴을 사용하여 생기는 유지보수 및 코드의 가독성 문제는 정수를 사용하여 해결할 수 있다. 리터럴을 사용한 부분을 정수로 바꾼 코드는 다음과 같다.

``` vhdl
architecture const_arch of add_w_carry is
  const N : integer := 4;
  signal a_ext, b_ext, sum_ext : unsigned(N downto 0);

begin
  a_ext <= unsigned('0' & a);
  b_ext <= unsigned('0' & b);
  sum_ext <= a_ext + b_ext;
  sum <= std_logic_vector(sum_ext(N-1 downto 0));
  co <= sum_ext(N);
end const_arch;
```

## Generics
VHDL에는 generic 이라 불리는 구조를 제공하며, 이는 정보를 entity 와 부품에 전달하는 역할을 한다. generic 은 architecture 내부에서 수정되지 않기 때문에, 이는 어느정도 정수와 비슷하다. generic 은 entity 내부에서 선언되며, port  이전에 정의된다.

``` vhdl
entity entity_name is
  generic(
    generic_name : data_type := default_values;
    generic_name : data_type := default_values;
    ...
    generic_name : data_type := default_values
  );
  
  port(
    ...
  );
end entity_name;
```

이전의 4bit 가산기도 generic 을 사용하여 다음과 같이 수정할 수 있다.

``` vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_add_w_carry is
  generic (N : integer := 4);
  
  port(
    a, b : in std_logic_vector(N-1 downto 0);
    co : out std_logic;
    sum : out std_logic_vector(N-1 downto 0)
  );
end gen_add_w_carry;

architecture arch of gen_add_w_carry is
  signal a_ext, b_ext, sum_ext : unsigned(N downto 0);

begin
  a_ext <= unsigned('0' & a);
  b_ext <= unsigned('0' & b);
  sum_ext <= a_ext + b_ext;
  sum <= std_logic_vector(sum_ext(N-1 downto 0));
  co <= sum_ext(N);
end arch;
```

generic N이 선언된 후에는, port 선언부와 architecture 에서 정수처럼 사용될 수 있다. 

