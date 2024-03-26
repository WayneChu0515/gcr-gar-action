
# build stage
# FROM node:16.17.1 as builder
FROM gcr.io/k8s-simpos/node:16.17.1 as builder

WORKDIR  /app
COPY package.json yarn.lock ./

RUN yarn install
# RUN yarn install --production
COPY . .
RUN yarn build

# runtime stage
FROM node:16-alpine as runtime
# FROM gcr.io/distroless/nodejs:16 as runtime

WORKDIR  /app
COPY --from=builder /app ./

EXPOSE 3000

ENV NODE_ENV=production
ARG GITHUB_TAG
ARG GITHUB_SHA
ENV GITHUB_TAG=${GITHUB_TAG}
ENV GITHUB_SHA=${GITHUB_SHA}

CMD ["yarn","start:prod"]


