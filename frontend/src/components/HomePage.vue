<template>
  <div class="app">
      <header-element />
      <router-view />
  </div>
</template>

<script>
import HeaderElement from './HeaderElement.vue';
export default {
  components: {
      HeaderElement  
  },
};
</script>



<style scoped>
router-link {
  margin-left: 0px;
}
.controls {
    margin-top: 20px;
    text-align: center;
}
button {
    margin: 5px;
    padding: 10px 20px;
    background-color: #555;
    color: white;
    border: none;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
}
button:hover {
    background-color: #777;
}
</style>
