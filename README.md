seq.lua는 배열, 즉 정수 색인 테이블의 순차적 접근을 위한 간단한 편의용 
라이브러리입니다.

사용 예:

    local seq = require"seq"

    local lines = seq.new_from_file('test.txt')

    for line in lines:iter() do
    	if line:find('^.$') then break end -- .만 있는 줄이면 
	    if line:find('^#') then  
	    	lines:next() -- #로 시작하는 줄은 건너 뜀
	    else
	        print(line)
	    end
    end

    assert(lines:current() == '.') -- 현재 원소(행)을 기억함

	print"-----------------\n"

    lines:prev() -- 또는 lines:unget()
    for line in lines:iter() do
    	print(line) -- '.' 줄 바로 전 줄부터 출력됨
    end

## 주요 함수 및 메서드


### seq.new(*table*)

    local seqob = seq.new(t)

주어진 테이블의 원소들을 담은 순차 배열 객체(seqobj)를 돌려줌

### seq.new_from_file(*filename*)

    local seqobj = seq.new_from_file(fn)

주어진 파일의 텍스트의 행들을 담은 seqobj를 돌려줌.

### seqobj의 메서드들

* `seqobj:current()` -- 현재 원소를 돌려줌
* `seqobj:next()` -- 다음 원소를 현재 원소로 만들고 그것을 돌려줌. 다음 원소가 없으면 nil을 돌려줌.
* `seqobj:prev()` -- 이전 원소를 현재 원소로 만들고 그것을 돌려줌. 이전 원소가 없으면 nil을 돌려줌.
*  `seqobj:seek(n)` -- n번째 원소를 현재 원소로 만들고 그것을 돌려줌. 해당 원소가 없으면 nil을 돌려줌.

### seq.util

몇 가지 보조 함수들을 담은 테이블.

* `seq.util.explode(`*src*, *sep*, *no_regex = false*`)` -- 주어진 문자열(`src`)를 주어진 구분자(`sep`)를 이용해서 분해한 담은 테이블을 돌려준다. `table.concat()`의 반대. `no_regex`를 `true`로 지정하면 구분자에 대해 패턴 부합이 적용되지 않는다.
