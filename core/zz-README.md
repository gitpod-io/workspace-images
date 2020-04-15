This directory is dedicated to core Dockerimages available for the end-user

### Abstract
- All the cores need noVNC for theia's desktop to work


---

=== START-OF-FIXME ===

It is expected to allow `.gitpod.yml` to use these images by providing following:
```yml
- dist: <name-of-core>
```
for gitpod to expand in:
```dockerfile
FROM gitpod/<name-of-core>
```

which would eliminate the need for `.gitpod.Dockerfile` for repositories that does not need them

=== END-OF-FIXME ===

---

=== START-OF-FIXME ===

It is also expected to allow end-user to set `.gitpod.yml` such as:
```yml
packages:
 - nano
 - vim
```

for gitpod to expand in:
```dockerfile
FROM gitpod/<name-of-core>

RUN <logic-based-on-core-used>
```

So that end-users can change the core without depending on dockerfiles

=== END-OF-FIXME ===

