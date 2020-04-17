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

---

=== START-OF-FIXME(Kreyren) === 

We have a duplicate code in the code i.e

```dockerfile
# Configure expected shell
COPY core/scripts/shellConfig.bash /usr/bin/shellConfig
# FIXME: This is expected to be set by gitpod based on end-user preference
ENV expectedShell="bash"
RUN true \
  && chmod +x /usr/bin/shellConfig \
  && /usr/bin/shellConfig \
  && rm /usr/bin/shellConfig
```

Which should be sourced into a one dockerfile, i don't have the tools and permission needed for implementing this

=== END-OF-FIXME(Kreyren) ===