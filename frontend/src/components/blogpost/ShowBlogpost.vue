   <template>
   <div class="blogpost-details" v-if="Object.keys(blogPost).length != 0">
        <img :src="blogPost.post.image_url" :alt="blogPost.post.title" class="blog-image">
        <div class="blog-content">
            <div class="content-row">
                <span class="label">Title</span>
                <h3 class="blog-title">{{ blogPost.post.title }}</h3>
            </div>
            <div class="content-row">
                <span class="label">Author</span>
                <p class="blog-author">{{ blogPost.user.firstname }} {{ blogPost.user.lastname }}</p>
            </div>
            <div class="content-row description">
                <span class="label">Description</span>
                <p class="blog-description">{{ blogPost.post.description }}</p>
            </div>
            <div class="content-row">
                <div v-if="isEditable(blogPost)">
                    <router-link :to="`/new-blogpost/${blogPost.post.id}`" class="nav-button auth-button">Edit</router-link>
                    <button class="nav-button auth-button" @click="deletePost">Delete</button>
                </div>
                
                <router-link :to="`/blogpost`" class="nav-button auth-button">Back</router-link>
            </div>
            <div id="comments">
                <h2>Comments</h2>

                <form @submit.prevent="addComment" class="add-comment-form">
                    <textarea
                        v-model="newComment"
                        placeholder="Write a comment..."
                        class="form-control"
                        rows="2"
                        required
                    ></textarea>
                    <button type="submit" class="btn btn-primary btn-sm">Add Comment</button>
                </form>
                <div v-for="comment in comments" :key="comment.id" class="comment">
                    <p>
                        <strong>{{ comment.user?.firstname }}:</strong> {{ comment.body }}
                    </p>

                    <div v-if="isEditable(comment)">
                        <button @click="deleteComment(comment.id)" class="btn btn-danger btn-sm">Delete</button>
                    </div>

                    <div  v-for="reply in comment.replies" :key="reply.id" class="reply">
                        <p>
                            <strong>{{ reply.user?.firstname }}:</strong> {{ reply.body }}
                        </p>
                        <div v-if="isEditable(reply)">
                            <button @click="deleteComment(reply.id)" class="btn btn-danger btn-sm">Delete</button>
                        </div>
                    </div>
                    <form @submit.prevent="addReply(comment.id)" :key="comment.id"  class="reply-form">
                        <textarea
                            v-model="replyContent[comment.id]"
                            placeholder="Write a reply..."
                            class="form-control"
                            rows="1"
                            required
                            
                        ></textarea>
                        <button type="submit" class="btn btn-primary btn-sm">Reply</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
import { mapGetters } from 'vuex';

export default {
    name: 'ShowBlogpost',
    data() {
        return {
            blogPost: {},
            comments: [],
            newComment: '',
            replyContent: {},
        };
    },
    computed: {
        ...mapGetters('auth', ['getUser']),
        userToken() {
            return this.getUser.user_token;
        },
        user() {
            return this.getUser.current_user;
        },
    },
    created() {
        this.fetchBlogPost();
    },
    methods: {
        async fetchBlogPost() {
            try {
                const response = await axios.get(`http://127.0.0.1:3000/api/v1/blog_posts/${this.$route.params.id}`, {
                    headers: { Authorization: `Bearer ${this.userToken}` },
                });
                this.blogPost = response.data;
                this.comments = response.data.comments;
            } catch (error) {
                console.error('Error fetching blog post:', error);
            }
        },
        async addComment() {
            try {
                const response = await axios.post(
                    'http://127.0.0.1:3000/api/v1/comments',
                    {
                        body: this.newComment,
                        blog_post_id: this.blogPost.post.id,
                    },
                    { headers: { Authorization: `Bearer ${this.userToken}` } }
                );
                this.comments.push(response.data);
                this.newComment = '';
                this.fetchBlogPost();
            } catch (error) {
                console.error('Error adding comment:', error);
            }
        },
        async addReply(parentId) {
            try {
                const response = await axios.post(
                    'http://127.0.0.1:3000/api/v1/comments',
                    {
                        body: this.replyContent[parentId],
                        parent_id: parentId,
                        blog_post_id: this.blogPost.post.id,
                    },
                    { headers: { Authorization: `Bearer ${this.userToken}` } }
                );
                const parentComment = this.comments.find((comment) => comment.id === parentId);
                parentComment.replies.push(response.data);
                this.replyContent = {};
                this.fetchBlogPost();
            } catch (error) {
                console.error('Error adding reply:', error);
            }
        },
        async deleteComment(commentId) {
            try {
                await axios.delete(`http://127.0.0.1:3000/api/v1/comments/${commentId}`, {
                    headers: { Authorization: `Bearer ${this.userToken}` },
                });
                this.fetchBlogPost();
            } catch (error) {
                console.error('Error deleting comment:', error);
            }
        },
        isEditable(item) {
            return item.user?.id === this.user.id;
        },
    },
};
</script>

<style scoped>
.blogpost-details {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.blog-image {
    width: 100%;
    height: auto;
    border-radius: 10px;
}

.blog-content {
    padding: 20px;
    background: linear-gradient(135deg, #c2ecd9 0%, #a8e6c9 100%);
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.content-row {
    display: flex;
    align-items: flex-start;
    gap: 12px;
}

.label {
    min-width: 90px;
    font-weight: 600;
    color: #2c3e50;
    background-color: rgba(255, 255, 255, 0.7);
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 0.9em;
    text-align: center;
}

.blog-title {
    font-size: 1.3em;
    margin: 0;
    color: #2c3e50;
    font-weight: 600;
    flex: 1;
    line-height: 1.4;
}

.blog-author {
    font-size: 1em;
    color: #2c3e50;
    margin: 0;
    flex: 1;
    line-height: 1.8;
}

.blog-description {
    font-size: 1em;
    color: #2c3e50;
    margin: 0;
    flex: 1;
    line-height: 1.6;
}
.description{
    flex-direction: column;
}
.content-row {
    display: flex;
    justify-content: flex-start; /* Align items to the left */
    gap: 10px; /* Add spacing between buttons */
    margin-top: 20px;
}
#comments {
    margin-top: 30px;
    padding: 20px;
    background: #ffffff;
    border-radius: 15px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}

#comments h2 {
    margin-bottom: 15px;
    font-size: 1.6em;
    color: #34495e;
    border-bottom: 2px solid #e1e1e1;
    padding-bottom: 10px;
}

.comment, .reply {
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 10px;
    background: #f4f6f7;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.comment p, .reply p {
    margin: 0;
    font-size: 1em;
    color: #34495e;
}

.comment strong, .reply strong {
    color: #27ae60;
}

.reply {
    margin-left: 20px;
    border-left: 4px solid #27ae60;
    padding-left: 15px;
}

.nav-button {
    padding: 10px 20px;
    border-radius: 10px;
    font-size: 1em;
    font-weight: 600;
    transition: all 0.3s ease-in-out;
    border: none;
    cursor: pointer;
    text-align: center;
    color: #ffffff;
    background: linear-gradient(135deg, #2ecc71, #27ae60);
}

.nav-button:hover {
    background: linear-gradient(135deg, #27ae60, #1e874b);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    transform: translateY(-2px);
}
.auth-button {
    flex: none; 
    max-width: 150px; 
    text-align: center;
    text-decoration: none;
}

.add-comment-form, .reply-form {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 20px;
}

textarea.form-control {
    resize: none;
    border: 1px solid #dcdcdc;
    border-radius: 10px;
    padding: 10px;
    font-size: 1em;
    color: #34495e;
}

textarea.form-control:focus {
    outline: none;
    border-color: #27ae60;
    box-shadow: 0 0 8px rgba(39, 174, 96, 0.3);
}

button {
    padding: 10px;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    font-size: 1em;
    transition: all 0.3s ease-in-out;
}

button.btn-primary {
    background: linear-gradient(135deg, #3498db, #2980b9);
    color: #ffffff;
}

button.btn-primary:hover {
    background: linear-gradient(135deg, #2980b9, #2574a9);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
}

button.btn-secondary {
    background: #ecf0f1;
    color: #7f8c8d;
}

button.btn-secondary:hover {
    background: #bdc3c7;
    color: #34495e;
}

button.btn-danger {
    background: #e74c3c;
    color: #ffffff;
}

button.btn-danger:hover {
    background: #c0392b;
    transform: translateY(-2px);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
}
</style>