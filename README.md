## 🔄 How It Works (Business Logic)

### The Basic Flow:
1. **User signs up** → Creates account with email/password
2. **User finds organization** → Browses list of available organizations  
3. **User requests to join** → Clicks "Join" and writes optional message
4. **Admin gets notification** → Sees pending request in Admin Panel
5. **Admin decides** → Approves or rejects the request
6. **User gets access** → Can now see organization's projects and content

### What Each Role Can Do:

** Employee (Basic Member):**
- View organization page and members
- See all projects in the organization
- Cannot create new projects
- Cannot manage other people

** Manager:**
- Everything Employee can do, PLUS:
- Create new projects
- Edit projects they created
- Mark projects as complete

** Admin:**
- Everything Manager can do, PLUS:
- Approve/reject membership requests
- Change anyone's role (promote Employee to Manager, etc.)
- Edit organization details
- Remove ymployees/members from organization


#  How to  setup project locally

## Stack
- ruby 3.3.3
- rails 7.1.5
- node 21.7.3
- postgres 11

### how to setup application

- bundle install
- rails db:create
- rails db:migrate
- rails db:seeds
- rails s


# the link for mini demo how works application 

- https://drive.google.com/file/d/19HEYsj5iSOqtP02mgckgm4aYpwfUKh9p/view
