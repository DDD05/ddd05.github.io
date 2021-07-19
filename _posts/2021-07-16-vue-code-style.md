---
layout: post
title: 'Vue Code Style'
date: 2021-07-16
categories: ''
tags: []
description: 'Vue 스타일 가이드를 해석해서 기록해둠'
---

# 📖 들어가기

Vue.js 프레임워크를 조금더 깔끔하고 제대로 사용하기 위해서 Vue API에서 제공하는 코드 스타일을 해석해서 기록하면 공부해볼 예정이다.

필수적으로 지켜줘야하는 것들과 매우추천, 추천, 주의 정도의 강도로 요구된다. 

<br>

# 필수 규칙

## 컴포넌트 이름에 합성어 사용

> Vue에서 제공되는 빌트인 컴포넌트를 제외하고 컴포넌트 이름은 항상 합성어를 사용해야한다.

- 모든 HTML 엘리먼트의 이름은 한 단어이기 때문에 합성어를 사용해서 충돌을 방지한다.

## 컴포넌트 데이터

> 컴포넌트의 `data`는 반드시 함수여야 한다.

- `data`의 값이 오브젝트일 경우, 컴포넌트의 모든 인스턴스가 공유된다. 이말은즉슨 다른 곳에서 컴포넌트를 재사용한다면 data객체를 참조하므로 데이터가 변경된다는 뜻이다. <br>
각 컴포넌트는 자체 data만을 관리하기를 원하기 때문에 이같은 문제가 발생하지 않기 위해서는 고유한 data 객체를 생성해야 한다.

## Props 정의

> Prop은 가능한 상세하게 정의되어야한다.

- 컴포넌트의 API를 문서화하므로 컴포넌트의 사용 방법을 쉽게 알 수 있는 장점이 있다.
- Vue는 타입을 정의할 수 있는 기능이 내장되어 있는데 이를 어기면 경고 메시지를 표시하여 잠재적 오류를 막을 수 있도록 도와준다.

## `v-for`에 `key` 지정

> v-for는 key와 항상 함께 사용

- 에니메이션의 객체 불변성과 같은 예측 가능한 행동을 유지하는것 <br>
Vue는 가상 DOM 방식을 체택하고 있으며 가능한 적은 DOM을 움직여서 렌더링을 최적화하는데 key값을 설정하므로써 Vue의 움직임을 예측 가능하게 합니다.

## `v-if`와 `v-for`를 동시에 사용하지말자

> v-for가 사용된 엘리먼트에 절대 v-if를 사용하지 말자.

### Bad 

- 리스트 목록을 필터링하기 위해서 아래와 같은 방법을 사용한다.

```html
<div v-for="user in users" v-if="user.isActive"></div>
```
**이 경우 computed 속성을 사용해서 필터링된 목록으로 대체해서 사용해야한다.**

- 리스트의 내용을 숨기기 위해서는 아래와 같은 방법을 사용한다.

```html
<div v-for="user in users" v-if="shouldShowUsers">
```
**이 경우 `v-if`를 컨테이너 엘리먼트로 옮겨 사용한다.**

### Good

- 필터링된 목록은 변경 사항이 있는 경우에만 계산되므로 필터링 효율성을 높일 수 있다.
- `v-for="user in activeUsers"`를 사용하면 렌더링 중에 활성 사용자만 반복되므로 렌더링 효율성이 증가한다.
- 로직이 계층에서 분리되므로 유지 관리(확장성)이 쉬워진다.

## 컴포넌트 스타일 스코프

최상위 APP 구성 요소와 레이아웃 구성 요소의 스타일이 전역적일 수 있지만 다른 구성의 컴포넌트의 경우 범위는 항상 지정되어야 한다.

싱글 파일 컴포넌트의 경우 style영역에 `scoped`를 속성을 통해 해당 컴포넌트에서만 사용되도록 스타일을 지정할 수 있다.

- 대형 프로젝트나 다른 개발자와 함께 작업할 때 scoped 설정은 스타일의 충돌을 최소화 할 수 있다.

## Private 속성 이름

> 플러그인, mixin 등에서 커스텀 사용자 private 프로퍼티는 항상 접두사 `$_`를 사용하는 것을 권장. <br>
다른 사람의 코드와 충돌을 피하려면 named scope를 사용.

Vue 에서는 접두사로 `_`와 `$`를 사용중이기 때문에 이를 혼합한 `$_`를 사용하여 private 속성을 구분하는 사용할 수 있다.

```js
var myGreatMixin = {
    // ...
    methods: {
      $_myGreatMixin_update: function () {
        // ...
      }
    }
}
```

```js
// Even better!
var myGreatMixin = {
  // ...
  methods: {
    publicMethod () {
      // ...
      myPrivateFunction()
    }
  }
}

function myPrivateFunction () {
  // ...
}

export default myGreatMixin
```

<br>

# 매우 추천함 (가독성 향상을 위함)

## 컴포넌트 파일

> 컴포넌트 파일을 이용하여 파일 시스템 환경의 연결을 쉽게하고 빠르게 찾을 수 있게 한다.

### Bad 

```js
Vue.component('TodoList', {
  // ...
})
Vue.component('TodoItem',{
  // ...
})
```

### Good
```
components/
|- TodoList.vue
|- TodoItem.vue
```

## 싱글 파일 컴포넌트 이름 규칙 지정(casing)

> 싱글 파일 컴포넌트의 이름을 지정할땐 PascalCase 또는 kebab-case을 사용한다.

## 베이스 컴포넌트 이름

> 기본 컴포넌트에 컨벤션으로 prefix `Base`, `App`, `V`를 사용하여 구분한다. 컨벤션을 이용하여 전역 컴포넌트로 등록하여 사용가능하다.

### Example

```
components\
|- BaseButton.vue
|- BaseTable.vue
|- BaseIcon.vue
```

```
components\
|- AppButton.vue
|- AppTable.vue
|- AppIcon.vue
```

### 베이스 컴포넌트 전역 컴포넌트로 등록

```js
// main.js
let requireComponent = require.context('./src/components', false, /^Base[A-Z].(vue|js|ts)$/)
requireComponent.keys().forEach(fileName => {
  let baseComponentConfig = requireComponent(fileName)
  baseComponentConfig = baseComponentConfig.default || baseComponentConfig
  let baseComponentName = baseComponentConfig.name || (
    fileName
      .replace(/^.+\//, '')
      .replace(/\.\w+$/, '')
  )
  Vue.component(baseComponentName, baseComponentConfig)
})
```

## 싱글 인스턴스 컴포넌트 이름

> 인스턴스가 하나만 있어야하는 구성 요소의 접두사`The`로 시작한다. 하나만 있음을 나타낸다. 

- 한페이지당 한번만 사용되는 요소
- props를 허용하지 않는 요소
- props를 추가해야하지만 한번만 사용되는 재사용 가능한 요소

### Bad

```
components/
|- Heading.vue
|- MySidebar.vue
```

### Good
```
components/
|- TheHeading.vue
|- TheSidebar.vue
```

## 강한 연관성을 가진 컴포넌트 이름

...

> 참고 <br>
> [https://kr.vuejs.org/v2/style-guide/](https://kr.vuejs.org/v2/style-guide/)