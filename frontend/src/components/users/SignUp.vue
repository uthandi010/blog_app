<template>
    <div class="page-wrapper">
      <div class="container">
        <h2>Sign Up</h2>
        <form @submit.prevent="submitForm">
          <div class="form-group">
            <label for="firstName">First Name</label>
            <input 
              type="text" 
              id="firstName" 
              v-model="firstName" 
              required 
              placeholder="Enter your first name"
            />
          </div>
          <div class="form-group">
            <label for="lastName">Last Name</label>
            <input 
              type="text" 
              id="lastName" 
              v-model="lastName" 
              required 
              placeholder="Enter your last name"
            />
          </div>
          <div class="form-group">
            <label for="email">Email</label>
            <input 
              type="email" 
              id="email" 
              v-model="email" 
              required 
              placeholder="Enter your email"
            />
          </div>
          <div class="form-group">
            <label for="password">Password</label>
            <input 
              type="password" 
              id="password" 
              v-model="password" 
              required 
              placeholder="Choose a password"
            />
          </div>
          <button type="submit">Sign Up</button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import { mapActions } from 'vuex';
  import axios from 'axios';
  
  export default {
    data() {
      return {
        firstName: '',
        lastName: '',
        email: '',
        password: ''
      };
    },
    methods: {
      ...mapActions('auth', ['addUser']),
      async submitForm() {
        try {
          const response = await axios.post('http://127.0.0.1:3000/api/v1/users', {
            user: {
              firstname: this.firstName,
              lastname: this.lastName,
              email: this.email,
              password: this.password
            }
          }, {
            headers: {
              'Content-Type': 'application/json',
            }
          });
          
          this.addUser({
            user: response.data.user,
            token: response.data.user.remember_token
          });
          this.$router.push('/');
        } catch (error) {
          console.error('Error submitting form:', error.response?.data || error);
        }
      }
    }
  };
  </script>
  
  <style scoped>
  .page-wrapper {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #f6f9fc 0%, #eef2f7 100%);
    padding: 20px;
  }
  
  .container {
    background: linear-gradient(135deg, #c2ecd9 0%, #a8e6c9 100%);
    padding: 2.5rem;
    border-radius: 15px;
    box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 400px;
    position: relative;
    overflow: hidden;
  }
  
  .container::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 5px;
    background: linear-gradient(to right, #2ecc71, #27ae60);
  }
  
  h2 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 2rem;
    font-size: 2em;
    font-weight: 600;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1);
  }
  
  .form-group {
    margin-bottom: 1.5rem;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #2c3e50;
    font-size: 1.1rem;
    font-weight: 500;
  }
  
  input {
    width: 100%;
    padding: 0.8rem;
    border: 2px solid rgba(44, 62, 80, 0.1);
    border-radius: 8px;
    font-size: 1rem;
    transition: all 0.3s ease;
    background: rgba(255, 255, 255, 0.9);
  }
  
  input:focus {
    outline: none;
    border-color: #27ae60;
    box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.2);
  }
  
  input::placeholder {
    color: #95a5a6;
  }
  
  button {
    width: 100%;
    padding: 1rem;
    background: linear-gradient(135deg, #2ecc71 0%, #27ae60 100%);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 1.1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    margin-top: 1rem;
    text-transform: uppercase;
    letter-spacing: 1px;
  }
  
  button:hover {
    background: linear-gradient(135deg, #27ae60 0%, #219a52 100%);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(46, 204, 113, 0.2);
  }
  
  button:active {
    transform: translateY(0);
  }
  
  @media (max-width: 480px) {
    .container {
      padding: 2rem;
    }
  
    h2 {
      font-size: 1.75em;
    }
  
    button {
      padding: 0.8rem;
    }
  }
  </style>